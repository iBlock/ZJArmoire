//
//  ZJAHomeTableHeaderView.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/16.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol ZJAHomeTableHeaderDelegate: NSObjectProtocol {
    func refreshTableView(index: Int)
}

class ZJAHomeTableHeaderView: UIView {
    
    weak var delegate: ZJAHomeTableHeaderDelegate?
    var weatherList: [ZJAWeatherModel] = [ZJAWeatherModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        prepareUI()
        setUpViewContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configHeaderView(weathers: [ZJAWeatherModel]) {
        weatherList = weathers
        var count = 0
        for subview in scrollView.subviews {
            if subview.isKind(of: ZJAHomeSectionHeaderView.self) {
                (subview as! ZJAHomeSectionHeaderView).configSection(weather: weatherList[count])
                count += 1
            }
        }
    }
    
    private func prepareUI() {
        
        scrollView.contentSize = CGSize(width:size.width*7, height:frame.height)
        var x:CGFloat = 0
        for i in 0...6 {
            let rect = CGRect(x: x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
            let section = ZJAHomeSectionHeaderView(frame: rect)
            if i > 0 {
                section.airQualityLabel.isHidden = true
            }
            scrollView.addSubview(section)
            x += frame.size.width
        }
        addSubview(scrollView)
        addSubview(pageController)
    }
    
    private func setUpViewContraints() {
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(frame.height)
        }
        
        pageController.snp.makeConstraints { (make) in
            make.top.equalTo(174-30)
            make.centerX.equalToSuperview()
        }
    }
    
    //点击页控件时事件处理
    func pageChanged(sender:UIPageControl) {
        //根据点击的页数，计算scrollView需要显示的偏移量
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        //展现当前页面内容
        scrollView.scrollRectToVisible(frame, animated:true)
        delegate?.refreshTableView(index: sender.currentPage)
    }
    
    public lazy var pageController:UIPageControl = {
        let pageController = UIPageControl()
        pageController.backgroundColor = UIColor.clear
        pageController.numberOfPages = 7
        pageController.addTarget(self, action: .pageControlValueChange, for: .valueChanged)
        return pageController
    }()
    
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = COLOR_MAIN_APP
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
}

private extension Selector {
    static let pageControlValueChange = #selector(ZJAHomeTableHeaderView.pageChanged(sender:))
}

extension ZJAHomeTableHeaderView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //通过scrollView内容的偏移计算当前显示的是第几页
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //设置pageController的当前页
        pageController.currentPage = page
        delegate?.refreshTableView(index: page)
    }
}

class ZJAHomeSectionHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = COLOR_MAIN_APP
        
        
        prepareUI()
        setUpViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        addSubview(temperatureLabel)
        addSubview(weatherImage)
        addSubview(weatherLabel)
        addSubview(weatherTempLabel)
        addSubview(updateTimerLabel)
        addSubview(dateLabel)
        addSubview(windPowerLabel)
        addSubview(airQualityLabel)
        addSubview(lineView)
        addSubview(lineView2)
    }
    
    public func configSection(weather: ZJAWeatherModel) {
        /*
        temperatureLabel.text = weather.nowTemp + "°"
        weatherImage.image = weather.img
        weatherLabel.text = weather.nightTemp+"~"+weather.dayTemp+"°"+" "+weather.winddirect+" "+weather.windpower
        airQualityLabel.text = weather.aqi
        if let updateTime = weather.updateTime {
            updateTimerLabel.text = updateTime+" 更新"
        }
 */
        temperatureLabel.text = "19°C"
        let url = URL(string: "http://app1.showapi.com/weather/icon/day/01.png")
        weatherImage.kf.setImage(with: url)
        weatherLabel.text = "多云"
        dateLabel.text = "3月10日 今天"
        updateTimerLabel.text = "22:53 更新"
        windPowerLabel.text = "东北风 1级"
        weatherTempLabel.text = "1 ~ 21°C"
        airQualityLabel.text = "43 优"
    }
    
    // MARK: - 统一添加界面约束
    
    private func setUpViewConstraints() {
        temperatureLabel.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview().offset(-100)
            make.right.equalTo(weatherImage.snp.left).offset(-20)
            make.top.equalTo(20)
        }
        
        weatherImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(50)
            make.top.equalTo(40)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        weatherLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(weatherImage.snp.right).offset(5)
            make.top.equalTo(70)
        })
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.right.equalTo(-5)
        }
        
        updateTimerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.right.equalTo(-5)
        }
        
        weatherTempLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(temperatureLabel.snp.bottom).offset(15)
        }
        
        windPowerLabel.snp.makeConstraints { (make) in
            make.right.equalTo(weatherTempLabel.snp.left).offset(-40)
            make.top.equalTo(weatherTempLabel)
        }
        
        airQualityLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(weatherTempLabel.snp.right).offset(40)
            make.top.equalTo(weatherTempLabel)
        })
        
        lineView.snp.makeConstraints({ (make) in
            make.right.equalTo(weatherTempLabel.snp.left).offset(-20)
            make.size.equalTo(CGSize(width:0.5,height:20))
            make.top.equalTo(weatherTempLabel).offset(0)
        })
        
        lineView2.snp.makeConstraints { (make) in
            make.left.equalTo(weatherTempLabel.snp.right).offset(20.5)
            make.size.equalTo(CGSize(width:0.5,height:20))
            make.top.equalTo(weatherTempLabel).offset(0)
        }
    }
    
    //MARK: - Setter and Getter
    
    /** 温度 */
    private lazy var temperatureLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 64)
        label.textColor = UIColor.white
        return label
    }()
    
    /** 天气图片 */
    private lazy var weatherImage:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    /** 温度详细 */
    /*
    private lazy var weatherInfoView:UIView = {
        let weatherView = UIView()
        weatherView.addSubview(self.lineView)
        weatherView.addSubview(self.weatherLabel)
        weatherView.addSubview(self.airQualityLabel)
        return weatherView
    }()
 */
    
    /** 风力大小 */
    private lazy var windPowerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    /** 天气范围 */
    private lazy var weatherTempLabel:UILabel = {
        let weatherLabel = UILabel()
        weatherLabel.text = "null ~ null°C"
        weatherLabel.textColor = UIColor.white
        weatherLabel.font = UIFont.systemFont(ofSize: 17)
        return weatherLabel
    }()
    
    /** 空气质量 */
    public lazy var airQualityLabel:UILabel = {
        let airQualityLabel = UILabel()
//        airQualityLabel.layer.cornerRadius = 10.0
//        airQualityLabel.layer.masksToBounds = true
//        airQualityLabel.backgroundColor = UIColor.colorWithHexString(hex: "7ED321")
        airQualityLabel.text = "null null"
        airQualityLabel.font = UIFont.systemFont(ofSize: 17)
        airQualityLabel.textAlignment = .center
        airQualityLabel.textColor = UIColor.white
        return airQualityLabel
    }()
    
    private lazy var lineView:UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.white
        return lineView
    }()
    
    private lazy var lineView2: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.white
        return lineView
    }()
    
    /** 更新时间 */
    private lazy var updateTimerLabel:UILabel = {
        let timerLabel = UILabel()
        timerLabel.textAlignment = .center
        timerLabel.textColor = UIColor.white
        timerLabel.text = "null 更新"
        timerLabel.font = UIFont.systemFont(ofSize: 10)
        return timerLabel
    }()
    
    /** 日期 */
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
}

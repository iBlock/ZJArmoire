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
            if i == 0 {
                section.temperatureLabel.font = UIFont.boldSystemFont(ofSize: 50)
                section.temperatureLabel.snp.updateConstraints({ (make) in
                    make.top.equalTo(0)
                })
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
            make.top.equalTo(height-40)
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
        addSubview(updateTimerLabel)
        addSubview(dateLabel)
        addSubview(content1)
        addSubview(weatherDetailLabel)
    }
    
    public func configSection(weather: ZJAWeatherModel) {
        temperatureLabel.text = weather.nowTemp + "°C"
        weatherImage.kf.setImage(with: weather.imgUrl)
        weatherLabel.text = weather.weather
        dateLabel.text = weather.formatDateStr
        updateTimerLabel.text = weather.updateFormatStr
        
        let powerStr = weather.winddirect + " " + weather.windpower
        let tempStr = weather.nightTemp + " ~ " + weather.dayTemp + "°C"
        let airStr = weather.aqi
        var weatherStr = powerStr + "  |  " + tempStr + "  |  " + airStr
        weatherStr = weatherStr.replacingOccurrences(of: "\n", with: "")
        weatherDetailLabel.text = weatherStr
    }
    
    // MARK: - 统一添加界面约束
    
    private func setUpViewConstraints() {
        content1.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.size.equalTo(CGSize(width: 200, height: 50))
            make.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { (make) in
            make.right.equalTo(weatherImage.snp.left).offset(-10)
            make.top.equalTo(5)
        }
        
        weatherImage.snp.makeConstraints { (make) in
            make.right.equalTo(weatherLabel.snp.left).offset(-10)
            make.top.equalTo(5)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        weatherLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(0)
            make.top.equalTo(30)
        })
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.right.equalTo(-5)
        }
        
        updateTimerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.right.equalTo(-5)
        }
        
        weatherDetailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(content1.snp.bottom).offset(20)
            make.left.right.equalTo(0)
        }
    }
    
    //MARK: - Setter and Getter
    
    private lazy var content1: UIView = {
        let content1: UIView = UIView()
        content1.addSubview(self.temperatureLabel)
        content1.addSubview(self.weatherImage)
        content1.addSubview(self.weatherLabel)
        return content1
    }()
    
    /** 天气详情 */
    private lazy var weatherDetailLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    /** 温度 */
    public lazy var temperatureLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .right
        label.textColor = UIColor.white
        return label
    }()
    
    /** 天气图片 */
    private lazy var weatherImage:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    /** 天气情况 */
    private lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    /** 风力大小 */
    private lazy var windPowerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    /** 更新时间 */
    private lazy var updateTimerLabel:UILabel = {
        let timerLabel = UILabel()
        timerLabel.textAlignment = .center
        timerLabel.textColor = UIColor.white
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

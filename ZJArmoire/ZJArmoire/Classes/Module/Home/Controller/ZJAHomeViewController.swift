//
//  ZJAHomeViewController.swift
//  ZJArmoire
//
//  Created by iBlock on 16/9/30.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit
import SnapKit

class ZJAHomeViewController: UIViewController, ZJAHomeTableViewDelegate {
    
    let KEY_TODAY = "TodayDapei"
    let KEY_TUIJIAN = "TuiJianDapei"
    var homeData: [String:[String:Any]] = ["0":[:]]
//    var currentIndexDic: [String: Any] = [:]
    var todayModel: ZJADapeiModel = ZJADapeiModel()
    var tuijianModels: [ZJADapeiModel] = [ZJADapeiModel]()
    var currentIndex = 0
    var weatherList = [ZJAWeatherModel]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
        prepareUI()
        setUpViewConstraints()
        
        requestWeatherNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "今天 · 北京";
    }
    
    func reloadHomeTable() {
        if let dapeiID = todayModel.dapei_id {
            ZJAMemonry.default.todayDapeiId = dapeiID
        }
        homeTableView.todayModel = todayModel
        homeTableView.tuiJianDapeiModels = tuijianModels
        DispatchQueue.main.async {
            self.homeTableView.tableHeader.configHeaderView(weathers: self.weatherList)
            self.homeTableView.reloadData()
        }
    }
    
    private func prepareData() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectorTodayDapeiCallback), name: NSNotification.Name(rawValue: KEY_NOTIFICATION_SELECTER_DAPEI), object: nil)
    }
    
    private func prepareUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(homeTableView)
    }
    
    private func setUpViewConstraints() {
        homeTableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(0.5)
            make.bottom.equalTo(-(tabBarController?.tabBar.size.height)!)
        }
    }
    
    // MARK: - Getter and Setter
    
    private lazy var homeTableView:ZJAHomeTableView = {
        let homeTable: ZJAHomeTableView = ZJAHomeTableView(frame: self.view.bounds, style: .plain)
        homeTable.tableDelegate = self
        homeTable.tableHeader.delegate = self
        return homeTable
    }()

}

extension ZJAHomeViewController {
    
    func requestWeatherNetwork() {
        DispatchQueue.global().async {
            ZJAWeatherNetwork.requestWeather { (result) in
                if let count = result?.count {
                    if count > 0 {
                        self.buildWeatherModels(result: result!)
                        self.fetchIndexData(index: 0)
                    }
                }
            }
        }
    }
    
    func fetchIndexData(index: Int) {
        currentIndex = index
        if weatherList.count == 0 {
            return
        }
        let weatherModel = weatherList[index]
        let nowDate = weatherModel.date
        let logTable = ZJATableDapeiLog()
        let dpModel = logTable.fetchDapeiModel(dateStr: nowDate)
        tuijianModels = logTable.fetchDapeiList(dayAir: Int(weatherModel.dayTemp), nightAir: Int(weatherModel.nightTemp))
        if let model = dpModel {
            todayModel = model
        } else {
            todayModel = ZJADapeiModel()
        }
        reloadHomeTable()
    }
    
    func buildWeatherModels(result: [String: Any]) {
        let todayWeather = ZJAWeatherModel()
        todayWeather.nowTemp = result["temp"] as! String
        todayWeather.dayTemp = result["temphigh"] as! String
        todayWeather.nightTemp = result["templow"] as! String
        todayWeather.winddirect = result["winddirect"] as! String
        todayWeather.windpower = result["windpower"] as! String
        
        let dateStr: String = result["date"] as! String
        todayWeather.date = dateStr.replacingOccurrences(of: "-", with: "")
        todayWeather.img = UIImage.imag(forweahter: result["img"] as! String)
        let aqiDic: [String:Any] = result["aqi"] as! [String : Any]
        let qualityStr: String = aqiDic["quality"] as! String
        todayWeather.aqi = aqiDic["aqi"] as! String! + "空气质量 " + qualityStr
        todayWeather.updateTime = result["updatetime"] as! String!
        weatherList.append(todayWeather)
        
        for i in 1...6 {
            let model = ZJAWeatherModel()
            let weathers: [[String:Any]] = result["daily"] as! [[String : Any]]
            let weather = weathers[i]
            let night:[String:String] = weather["night"] as! [String : String]
            let day:[String:String] = weather["day"] as! [String : String]
            model.nowTemp = weather["week"] as! String
            model.dayTemp = day["temphigh"]! as String
            model.nightTemp = night["templow"]! as String
            model.winddirect = day["winddirect"]! as String
            model.windpower = day["windpower"]! as String
            model.date = weather["date"] as! String
            model.img = UIImage.imag(forweahter: day["img"]! as String)
            weatherList.append(model)
        }
    }
    
}

extension ZJAHomeViewController: ZJAHomeTableHeaderDelegate {
    func refreshTableView(index: Int) {
        fetchIndexData(index: index)
    }
}

/// MARK - 选择今日搭配通知回调
extension ZJAHomeViewController {
    func selectorTodayDapeiCallback(notification: Notification) {
        let dapeiModel: ZJADapeiModel = notification.object as! ZJADapeiModel
        let weatherModel = weatherList[currentIndex]
        let table = ZJATableDapeiLog()
        table.dapeiDateStr = weatherModel.date
        table.dapeiID = dapeiModel.dapei_id
        table.day_air = Int(weatherModel.dayTemp)
        table.night_air = Int(weatherModel.nightTemp)
        let isSuccess = table.update()
        
        if isSuccess == true {
            todayModel = dapeiModel
            reloadHomeTable()
        }
    }
}

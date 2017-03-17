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
    
}

extension ZJAHomeViewController: ZJAHomeTableHeaderDelegate {
    func refreshTableView(index: Int) {
        fetchIndexData(index: index)
    }
}

/// MARK: - 选择今日搭配通知回调
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

/// MARK: - 解析天气数据
extension ZJAHomeViewController {
    func buildWeatherModels(result: [String: Any]) {
        let todayWeather: ZJAWeatherModel = ZJAWeatherModel()
        todayWeather.analysisTodayWeatherData(resultDic: result)
        weatherList.append(todayWeather)
        
        for i in 2...7 {
            let model = ZJAWeatherModel()
            let weather: [String:Any] = result["f"+String(i)] as! [String : Any]
            model.analysisWeatherData(resultDic: weather)
            model.updateFormatStr = todayWeather.updateFormatStr
            weatherList.append(model)
        }
    }
}

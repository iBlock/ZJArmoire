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
    
    func didTappedButton(sender: UIButton) {
        navigationController?.pushViewController(ZJAAddDapeiController(), animated: true)
    }
    
    func reloadHomeTable() {
        DispatchQueue.main.async {
            self.homeTableView.todayModel = self.todayModel
            self.homeTableView.tuiJianDapeiModels = self.tuijianModels
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
        return homeTable
    }()

}

extension ZJAHomeViewController {
    
    func requestWeatherNetwork() {
        DispatchQueue.global().async {
            ZJAWeatherNetwork.requestWeather { (result) in
                //            let resultDic: [String:Any] = result!
                //            let a = resultDic["hello"]
                
                self.fetchIndexData(index: 0)
                self.reloadHomeTable()
            }
        }
    }
    
    func fetchIndexData(index: Int) {
        let nowDate = String.getNowDateStr()
        let logTable = ZJATableDapeiLog()
        let dpModel = logTable.fetchDapeiModel(dateStr: nowDate)
        tuijianModels = logTable.fetchDapeiList(dayAir: 5, nightAir: 15)
        if let model = dpModel {
            todayModel = model
        }
        homeData[String(index)] = [KEY_TODAY:todayModel,KEY_TUIJIAN:tuijianModels]
    }
    
}

/// MARK - 选择今日搭配通知回调
extension ZJAHomeViewController {
    func selectorTodayDapeiCallback(notification: Notification) {
        let dapeiModel: ZJADapeiModel = notification.object as! ZJADapeiModel
        let table = ZJATableDapeiLog()
        table.dapeiDateStr = String.getNowDateStr()
        table.dapeiID = dapeiModel.dapei_id
        table.day_air = 6
        table.night_air = 14
        let isSuccess = table.update()
        
        if isSuccess == true {
            todayModel = dapeiModel
            reloadHomeTable()
        }
    }
}

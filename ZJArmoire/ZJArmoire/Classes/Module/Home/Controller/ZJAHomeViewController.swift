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
    
    var homeData: [String:Any] = ["0":[]]
    var currentIndexDic: [String: Any] = [:]
    var currentIndex = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
        prepareUI()
        setUpViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "今天 · 北京";
        
        requestWeatherNetwork()
    }
    
    func didTappedButton(sender: UIButton) {
        navigationController?.pushViewController(ZJAAddDapeiController(), animated: true)
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
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0.5, 0, 0, 0))
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
        ZJAWeatherNetwork.requestWeather { (result) in
            let resultDic: [String:Any] = result!
            let a = resultDic["hello"]
        }
    }
    
}

/// MARK - 选择今日搭配通知回调
extension ZJAHomeViewController {
    func selectorTodayDapeiCallback(notification: Notification) {
        let dapeiModel: ZJADapeiModel = notification.object as! ZJADapeiModel
        let str = dapeiModel.dapei_id
    }
}

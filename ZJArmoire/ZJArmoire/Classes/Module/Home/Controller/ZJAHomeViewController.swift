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
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        setUpViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "今天 · 北京";
    }
    
    func didTappedButton(sender: UIButton) {
        navigationController?.pushViewController(ZJATodayDapeiController(), animated: true)
    }
    
    private func prepareUI() {
        view.backgroundColor = COLOR_MAIN_BACKGROUND
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

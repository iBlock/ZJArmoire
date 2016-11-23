//
//  ZJAHomeViewController.swift
//  ZJArmoire
//
//  Created by iBlock on 16/9/30.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit
import SnapKit

class ZJAHomeViewController: UIViewController {
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
    
    private func prepareUI() {
//        title = "今天 · 北京"

//        navigationItem.title = "今天 · 北京"
//        let titleLabel = UILabel()
//        titleLabel.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44)
//        titleLabel.textAlignment = .center
//        titleLabel.textColor = UIColor.white
//        titleLabel.backgroundColor = UIColor.clear
//        titleLabel.font = UIFont.systemFont(ofSize: 17)
//        titleLabel.text = "今天 · 北京"
//        
//        navigationItem.titleView = titleLabel
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        view.addSubview(homeTableView)
    }
    
    private func setUpViewConstraints() {
        homeTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0.5, 0, 0, 0))
        }
    }
    
    // MARK: - Getter and Setter
    
    private lazy var homeCollectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds)
        return collectionView
    }()
    
    private lazy var homeTableView:ZJAHomeTableView = {
        let homeTable = ZJAHomeTableView(frame: self.view.bounds, style: .plain)
        return homeTable
    }()

}

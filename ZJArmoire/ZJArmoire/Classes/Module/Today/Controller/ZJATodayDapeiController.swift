//
//  ZJATodayDapeiController.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/1/17.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation

class ZJATodayDapeiController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        setupViewConstraints()
    }
    
    private func prepareUI() {
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        title = "今日搭配"
        
        view.addSubview(dapeiCollectionView)
        view.addSubview(todaySelectorView)
    }
    
    private func setupViewConstraints() {
        dapeiCollectionView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(todaySelectorView.snp.top).offset(0)
        }
        
        todaySelectorView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(120)
        }
    }
    
    private lazy var dapeiCollectionView: ZJATypeListCollectionView = {
        let collectionView: ZJATypeListCollectionView = ZJATypeListCollectionView(frame: self.view.bounds)
        return collectionView
    }()
    
    private lazy var todaySelectorView: ZJATodayDapeiSelectorView = {
        let selectorView: ZJATodayDapeiSelectorView = ZJATodayDapeiSelectorView()
        return selectorView
    }()
    
}

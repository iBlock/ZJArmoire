//
//  ZJAYiGuiViewController.swift
//  ZJArmoire
//
//  Created by iBlock on 16/9/30.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJAYiGuiViewController: UIViewController {
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        
        prepareUI()
    }
    
    private func prepareUI() {
        navigationItem.title = "我的衣柜"
        view.addSubview(yiGuiTypeCollectionView)
        yiGuiTypeCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var yiGuiTypeCollectionView:ZJAYiGuiCollectionView = {
        
        let yiGuiTypeView = ZJAYiGuiCollectionView(frame: self.view.bounds)
        
        return yiGuiTypeView
    }()
}

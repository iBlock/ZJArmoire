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
//        navigationItem.rightBarButtonItem = rightBarButtonItem
        view.addSubview(yiGuiTypeCollectionView)
        yiGuiTypeCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Event and Respone
    
    @objc private func rightBarButtonClick(sender:UIBarButtonItem) {
        
    }
    
    private lazy var yiGuiTypeCollectionView:ZJAYiGuiCollectionView = {
        let yiGuiTypeView = ZJAYiGuiCollectionView(frame: self.view.bounds)
        return yiGuiTypeView
    }()
    
    /*
    private lazy var rightBarButtonItem:UIBarButtonItem = {
        var addImage = UIImage(named: "Global_Add")
        addImage = addImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let barItem = UIBarButtonItem(image: addImage,
                                      style: .plain,
                                      target: self,
                                      action:#selector(ZJAYiGuiViewController.rightBarButtonClick(sender:)))
        return barItem
    }()
 */
}

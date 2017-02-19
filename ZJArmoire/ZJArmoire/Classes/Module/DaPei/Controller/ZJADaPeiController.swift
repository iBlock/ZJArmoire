//
//  ZJADaPeiController.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/4.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJADaPeiController: UIViewController {
    
    var errorView: ZJAErrorView?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        ZJATableDapei().fetchAllDapei { [weak self] (dapeiList) in
            SVProgressHUD.dismiss()
            self?.prepareDapeiListData(dpList: dapeiList)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "搭配";
    }
    
    func prepareUI() {
        
    }
    
    func prepareDapeiListData(dpList: [ZJADapeiModel]) {
        if dpList.count == 0 {
            errorView = view.loadErrorView()
            errorView?.errorInfoText = "您还没有衣服搭配哦，赶快去搭配吧！"
            errorView?.errorButtonClick = { [weak self]() -> () in
                let addDapeiController = ZJAAddDapeiController()
                self?.navigationController?.pushViewController(addDapeiController, animated: true)
            }
        } else {
            errorView?.removeFromSuperview()
        }
    }
    
}

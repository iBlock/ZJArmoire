//
//  ZJAAddDapeiController.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJAAddDapeiController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        setUpViewConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func prepareUI() {
        title = "新建搭配"
        view.backgroundColor = UIColor.white
        view.addSubview(dapeiTableView)
//        let clothesList = ZJATableClothes().fetchAllClothes(0)
//        let view = ZJAPhotoJointView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH/2, height: 200), photoList: clothesList)
//        self.view.addSubview(view)
    }
    
    func setUpViewConstraints() {
        dapeiTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    private lazy var dapeiTableView: ZJANewDapeiTableView = {
        let tableView = ZJANewDapeiTableView(frame: CGRect.zero, style: .plain)
        return tableView
    }()
}

//
//  ZJAAddSKUController.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/11/22.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJAAddSKUController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        setUpViewConstraints()
    }
    
    private func prepareUI() {
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        title = "添加单品"
        view.backgroundColor = COLOR_MAIN_BACKGROUND
        view.addSubview(skuAddTableView)
    }
    
    func setUpViewConstraints() {
        
    }
    
    private lazy var skuAddTableView:ZJASKUAddTableView = {
        let clothesTableView = ZJASKUAddTableView(frame: self.view.bounds, style: .plain)
        return clothesTableView
    }()

}

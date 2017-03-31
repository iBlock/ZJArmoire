//
//  ZJAMineController.swift
//  ZJArmoire
//
//  Created by iBlock on 16/10/4.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJAMineController: UIViewController {
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "我的";
    }
    
}

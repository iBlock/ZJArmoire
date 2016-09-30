//
//  ZJATabBarViewController.swift
//  ZJArmoire
//
//  Created by iBlock on 16/9/30.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJATabBarController: UITabBarController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Getter and Setter
    
    private lazy var homeController: UIViewController = {
        let homeVc = ZJAHomeViewController()
        return homeVc
    }()
    
}

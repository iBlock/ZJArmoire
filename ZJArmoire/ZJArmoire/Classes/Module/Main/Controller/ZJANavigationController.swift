//
//  ZJANavigationController.swift
//  ZJArmoire
//
//  Created by iBlock on 16/9/30.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJANavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = navigationBar
        navBar.barTintColor = COLOR_MAIN_APP
        navBar.isTranslucent = false
        navBar.barStyle = UIBarStyle.black
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        
        navigationBar.titleTextAttributes = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 18),
            NSForegroundColorAttributeName : UIColor.white
        ]
    }
    
    /**
     拦截push操作，修改需要push的控制器的返回按钮
     
     - parameter viewController: 需要push的控制器
     - parameter animated:       是否有push动画
     */
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.leftItem(normalImage: "Global_Navi_Goback", highlightedImage: "Global_Navi_Goback", target: self, action: #selector(didTappedBackButton(button:)))
//            viewController.hidesBottomBarWhenPushed = true
        } else {
//            viewController.hidesBottomBarWhenPushed = false
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    /**
     返回事件
     */
    @objc private func didTappedBackButton(button: UIBarButtonItem) {
        popViewController(animated: true)
    }
    
}

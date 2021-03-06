//
//  ZJATabBarViewController.swift
//  ZJArmoire
//
//  Created by iBlock on 16/9/30.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJATabBarController: UITabBarController {
    
    static let sharedInstance = ZJATabBarController()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBar = UITabBar()
//        let tabBar = ZJATabBar()
//        tabBar.tabBarDelegate = self
        setValue(tabBar, forKey: "tabBar")
        tabBar.tintColor = COLOR_MAIN_APP
        
        prepareVc()
    }
    
    // MARK: - Private Method
    
    private func prepareVc() {
        viewControllers = [homeController,daPeiController,yiGuiViewController,mineController];
        selectedIndex = 0
    }
    
    private func configChildViewController(childViewController: UIViewController, title: String, imageName: String, selectedImageName: String) {
        childViewController.tabBarItem.title = title
        childViewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        childViewController.tabBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 12)], for: UIControlState.normal)
//        childViewController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.colorWithHexString(hex: "00bb9c")], for: UIControlState.highlighted)
        childViewController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        childViewController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
    }
    
    // MARK: - Getter and Setter
    
    /** 首页 */
    private lazy var homeController: UIViewController = {
        let homeVc = ZJAHomeViewController()
        self.configChildViewController(childViewController: homeVc, title: "首页", imageName: "Home", selectedImageName: "Home-Click")
//        return ZJANavigationController(rootViewController: homeVc)
        return homeVc
    }()
    
    /** 搭配 */
    private lazy var daPeiController: UIViewController = {
        let daPeiVc = ZJADaPeiController()
        self.configChildViewController(childViewController: daPeiVc, title: "搭配", imageName: "DaPei", selectedImageName: "DaPei-click")
//        return ZJANavigationController(rootViewController: daPeiVc)
        return daPeiVc
    }()
    
    /** 衣柜 */
    private lazy var yiGuiViewController: UIViewController = {
        let yiguiVc = ZJAYiGuiViewController()
        self.configChildViewController(childViewController: yiguiVc, title: "衣柜", imageName: "YiGui", selectedImageName: "YiGui-click")
//        return ZJANavigationController(rootViewController: yiguiVc)
        return yiguiVc
    }()
    
    /** 我的 */
    private lazy var mineController: UIViewController = {
        let mineVc = ZJAMineController()
        self.configChildViewController(childViewController: mineVc, title: "我的", imageName: "Mine", selectedImageName: "Mine-Click")
//        return ZJANavigationController(rootViewController: mineVc)
        return mineVc
    }()
    
}

// MARK: - ZJATabBarDelegate
extension ZJATabBarController: ZJATabBarDelegate {
    /** 点击添加按钮 */
    func didTappedAddButton() {
        let publicNaviController = ZJANavigationController(rootViewController: ZJACameraController())
        present(publicNaviController, animated: true, completion: nil)
    }
}

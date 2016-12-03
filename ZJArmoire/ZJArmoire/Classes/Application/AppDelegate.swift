//
//  AppDelegate.swift
//  ZJArmoire
//
//  Created by iBlock on 16/9/29.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupRootViewController()
        
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    // MARK: - Private Method
    
    /** 添加根控制器 */
    private func setupRootViewController() {
        window = UIWindow(frame: SCREEN_BOUNDS)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = ZJANavigationController(rootViewController: ZJATabBarController())
//        window?.rootViewController = ZJATabBarController()
        window?.makeKeyAndVisible()
        let debugConfig = DJDebugConfig()
        DJDebug.initWith(debugConfig)
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.toolbarDoneBarButtonItemText = "确认"
        keyboardManager.enable = true
    }
}


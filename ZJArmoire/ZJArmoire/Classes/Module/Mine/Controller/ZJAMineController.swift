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
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let zoomView: ZJACameraZoomView = ZJACameraZoomView(frame: frame, zoomImage: UIImage(named: "test2")!)
        zoomView.center = view.center
        view.addSubview(zoomView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "我的";
    }
    
}

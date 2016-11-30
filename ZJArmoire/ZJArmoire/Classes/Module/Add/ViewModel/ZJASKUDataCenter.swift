//
//  ZJASKUDataCenter.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/11/30.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUDataCenter: NSObject {
    static let sharedInstance = ZJASKUDataCenter()
    
    var skuItemArray:NSArray!
    
    private override init() {
        let testList = NSMutableArray()
        for _ in 1...3 {
            let skuModel = ZJASKUItemModel()
            skuModel.photoImage = UIImage(named: "test")
            testList.add(skuModel)
        }
        skuItemArray = testList
    }
}

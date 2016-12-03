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
    
    var skuItemArray:NSArray! = NSArray()
    private var skuItemMutableList:NSMutableArray! = NSMutableArray()
    
    public func getSKUItemModel(index:NSInteger) -> ZJASKUItemModel {
        return skuItemMutableList.object(at: index) as! ZJASKUItemModel
    }
    
//    public func updateItem(model:ZJASKUItemModel) {
//        skuModel.photoImage = model.photoImage
//        skuModel.tagList = model.tagList
//        skuModel.category = model.category
//    }
    
    public func addSKUItem(model:ZJASKUItemModel) {
        skuItemMutableList.add(model)
        skuItemArray = skuItemMutableList
    }
    
    public func removeSKUItem(index:NSInteger) {
        skuItemMutableList.removeObject(at: index)
        skuItemArray = skuItemMutableList
    }
    
    public func removeAllItem() {
        skuItemMutableList.removeAllObjects()
        skuItemArray = skuItemMutableList
    }
    
//    private override init() {
//        let testList = NSMutableArray()
//        for _ in 1...2 {
//            let skuModel = ZJASKUItemModel()
//            skuModel.photoImage = UIImage(named: "test")
//            testList.add(skuModel)
//        }
//        skuItemArray = testList
//    }
}

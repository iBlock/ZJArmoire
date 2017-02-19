//
//  ZJAClothesModel.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/14.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation

class ZJAClothesModel: NSObject {
    var clothesImg: UIImage!
    var uuid: String!
    var type: Int!
    var tags: String?
    var day_air: Int?
    var night_air: Int?
    
    override init() {
        super.init()
    }
    
    init(skuModel: ZJASKUItemModel) {
        super.init()
        clothesImg = skuModel.photoImage
        type = skuModel.category
        tags = skuModel.tagList?.joined(separator: ",")
        if tags?.characters.count == 0 {
            tags = nil
        }
    }
}

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
    
    /// 用来提升Cell滑动性能，如果有值直接使用，否则压缩后赋值
    var cellImg: UIImage?
    var isSelector: Bool = false
    
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

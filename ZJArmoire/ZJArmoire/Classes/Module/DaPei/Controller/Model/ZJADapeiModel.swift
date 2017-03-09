//
//  ZJADapeiModel.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/19.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit

class ZJADapeiModel: NSObject {
    var dapei_id: String!
    var dapei_time: String?
    var day_temp: Int?
    var night_temp: Int?
    var clothesList: Array<ZJAClothesModel>!
    var history_air: String!
    var clothesIdList: Array<String>!
    var taglist: Array<String>?
    
    /// 用来提升图片Cell滑动性能，如果有值直接使用，否则压缩后赋值
    var cellImg: UIImage?
}

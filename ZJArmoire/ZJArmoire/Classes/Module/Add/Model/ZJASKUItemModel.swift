//
//  ZJASKUItemModel.swift
//  ZJArmoire
//
//  Created by iBlock on 2016/11/30.
//  Copyright © 2016年 iBlock. All rights reserved.
//

import UIKit

class ZJASKUItemModel: NSObject {
    var photoImage:UIImage?
    var category:Int! = 0
    var tagList:Array<String>?
    var isSelecter:Bool! = false
    
    /// 用来提升Cell滑动性能，如果有值直接使用，否则压缩后赋值
    var cellImg: UIImage?
}

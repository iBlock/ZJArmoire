//
//  ZJAMemonry.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/3/4.
//  Copyright © 2017年 iBlock. All rights reserved.
//  全局临时存储对象

import UIKit

class ZJAMemonry: NSObject {
    
    static let `default` = ZJAMemonry()

    /// 今天选择搭配的ID
    var todayDapeiId: String = ""
}

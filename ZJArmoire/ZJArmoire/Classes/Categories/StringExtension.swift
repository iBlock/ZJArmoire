//
//  StringExtension.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/26.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation

extension String {
    
    static func generateUUID() -> String {
        let now = NSDate()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        let random = String(timeStamp) + String(arc4random())
        return random
    }
    
    /// 获取当前时间，格式为: 20170303
    static func getNowDateStr() -> String {
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyyMMdd"
        let dateStr = dformatter.string(from: now)
        return dateStr
    }
    
}

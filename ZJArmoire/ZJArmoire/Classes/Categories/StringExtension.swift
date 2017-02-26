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
    
}

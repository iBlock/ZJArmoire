//
//  ZJASQLiteManager.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/1/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation
import SQLite

struct ZJASQLiteManager {
    init() {
        createdsqlite3()
    }
    
    //创建数据库文件
    mutating func createdsqlite3()  {
        ZJATableClothes().initTable()
        ZJATableTags().initTable()
        ZJATableClothes_Tag().initTable()
        ZJATableDapei().initTable()
        ZJATableDapei_Clothes().initTable()
    }
    
}

//
//  ZJATableTags.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/1/16.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation
import SQLite

class ZJATableTags: NSObject {
    
    var tagName: String!
    var db: Connection!
    
    //标签表
    private let table_tag = Table("Table_Tag_List")
    private let t_tag_id = Expression<Int>("id")
    private let t_tag_name = Expression<String>("tag_name")
    
    func initTable() {
        let query = table_tag.create(ifNotExists: true, block: { (t) in
            t.column(t_tag_id, primaryKey: true)
            t.column(t_tag_name, unique: true)
        })
        
        let isSuccess = ZJASQLiteManager.default.runCreateDatabaseTable(querys: [query])
        if isSuccess == false {
            print("创建标签表失败\n")
        }
    }
    
    func insert() -> Bool {
        let insert = table_tag.insert(or: .ignore, (t_tag_name <- tagName))
        let isSuccess = ZJASQLiteManager.default.runInsertDatabase(querys: [insert])
        return isSuccess
    }
}

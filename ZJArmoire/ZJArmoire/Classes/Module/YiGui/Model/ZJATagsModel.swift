//
//  ZJATagsModel.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/1/16.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation
import SQLite

class ZJATagsModel: NSObject {
    
    var tagName: String!
    var db: Connection!
    
    //标签表
    private let table_tag = Table("Table_Tag_List")
    private let t_tag_id = Expression<Int64>("id")
    private let t_tag_name = Expression<String>("tag_name")
    
    func initTable() {
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(table_tag.create(ifNotExists: false, block: { (t) in
                t.column(t_tag_id, primaryKey: true)
                t.column(t_tag_name, unique: true)
            }))
        } catch {
            print(error)
        }
    }
    
    func insert() -> Bool {
        let insert = table_tag.insert(or: .ignore, (t_tag_name <- tagName))
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(insert)
            return true
        } catch {
            print(error)
            return false
        }
    }
}

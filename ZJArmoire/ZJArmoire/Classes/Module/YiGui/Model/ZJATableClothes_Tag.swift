//
//  ZJATableClothes_Tag.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/1/16.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation
import SQLite

class ZJATableClothes_Tag: NSObject {
    
    var clothes_id: String!
    var tag_id: String!
    var db: Connection!
    
    //衣服和标签的关联表
    private let table_clothes_tag = Table("Table_Clothes_Tag")
    private let t_yf_tag_id = Expression<Int>("id")
    private let t_yf_tag_clothes_id = Expression<String>("clothes_id")
    private let t_yf_tag_tag_id = Expression<String>("tag_id")
    
    func initTable() {
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(table_clothes_tag.create(ifNotExists: true, block: { (t) in
                t.column(t_yf_tag_id, primaryKey: true)
                t.column(t_yf_tag_clothes_id)
                t.column(t_yf_tag_tag_id)
            }))
            
            try db.run(table_clothes_tag.createIndex([t_yf_tag_clothes_id,t_yf_tag_tag_id], unique: true, ifNotExists: true))
        } catch {
            print("创建衣服和标签关联表失败")
            print(error)
        }
    }
    
    func insert() -> Bool {
        let insert = table_clothes_tag.insert(
            t_yf_tag_clothes_id <- clothes_id,
            t_yf_tag_tag_id <- tag_id)
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(insert)
            return true
        } catch {
            print("创建衣服和标签的关联表失败")
            print(error)
            return false
        }
    }
}

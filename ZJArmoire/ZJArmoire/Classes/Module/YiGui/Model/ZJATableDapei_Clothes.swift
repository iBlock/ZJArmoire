//
//  ZJATableDapei_Clothes.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/12.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation
import SQLite

class ZJATableDapei_Clothes: NSObject {
    var db: Connection!
    var clothes_id: String!
    var dapei_id: Int64!
    
    //衣服和搭配记录的关联表
    private let table_dapei_clothes = Table("Table_Clothes_Dapei")
    private let t_yf_dp_id = Expression<Int64>("id")
    private let t_yf_dp_yf_id = Expression<String>("clothes_id")
    private let t_yf_dp_dp_id = Expression<Int64>("dapei_id")
    
    func initTable() {
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(table_dapei_clothes.create(ifNotExists: true, block: { (t) in
                t.column(t_yf_dp_id, primaryKey: true)
                t.column(t_yf_dp_yf_id)
                t.column(t_yf_dp_dp_id)
            }))
            try db.run(table_dapei_clothes.createIndex([t_yf_dp_yf_id, t_yf_dp_dp_id], unique: true, ifNotExists: true))
        } catch {
            print("创建衣服和搭配记录的关联表失败")
            print(error)
        }
    }
    
    func insert() -> Bool {
        let insert = table_dapei_clothes.insert(t_yf_dp_yf_id <- clothes_id,
                                                t_yf_dp_dp_id <- dapei_id)
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(insert)
            return true
        } catch {
            print("插入衣服和搭配关联表失败")
            print(error)
            return false
        }
    }
    
}

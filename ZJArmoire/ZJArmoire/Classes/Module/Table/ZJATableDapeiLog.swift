//
//  ZJATableDapeiLog.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/24.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit
import SQLite

class ZJATableDapeiLog: NSObject {
    
    var dapeiID: Int!
    var db: Connection!
    var dapeiDateStr: String!
    
    private let table_dapei_log = Table("Table_DaPei_Log")
    private let t_dp_log_id = Expression<Int>("id")
    private let t_dp_log_date = Expression<String>("dapei_log_date")
    private let t_dp_log_dpid = Expression<Int>("dapei_log_dpid")
    
    func initTable() {
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(table_dapei_log.create(ifNotExists: true, block: { (t) in
                t.column(t_dp_log_id, primaryKey: true)
                t.column(t_dp_log_date, unique:true)
                t.column(t_dp_log_dpid)
            }))
        } catch {
            print("创建历史搭配打卡表失败")
            print(error)
        }
    }

    func insert() -> Bool {
        let insert = table_dapei_log.insert(t_dp_log_date <- dapeiDateStr,
                                            t_dp_log_dpid <- dapeiID)
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(insert)
            return true
        } catch {
            print("插入搭配记录表失败")
            print(error)
            return false
        }
    }
}

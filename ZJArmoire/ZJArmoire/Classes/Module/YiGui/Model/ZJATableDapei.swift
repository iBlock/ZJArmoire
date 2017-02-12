//
//  ZJATableDapei.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/12.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation
import SQLite

class ZJATableDapei: NSObject {
    
    var db: Connection!
    
    //搭配记录表
    private let table_dapei = Table("Table_DaPei_List")
    private let t_dapei_id = Expression<Int64>("id")
    private let t_dapei_date = Expression<String>("day_timer")
    private let t_dapei_day_air = Expression<Int64>("day_air_temperature")
    private let t_dapei_night_air = Expression<Int64>("night_air_temperature")
    //dapei_state搭配状态，0：衣服搭配 1：已使用搭配
    private let t_dapei_state = Expression<Int64>("dapei_state")
//    private let t_prepare_dapei_date = Expression<String>("prepare_dapei_date")
    
    func initTable() {
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(table_dapei.create(ifNotExists: false, block: { (t) in
                t.column(t_dapei_id, primaryKey: true)
                t.column(t_dapei_date)
                t.column(t_dapei_day_air)
                t.column(t_dapei_night_air)
            }))
        } catch {
            print("创建搭配记录表失败")
            print(error)
        }
    }
    
    /** 根据时间查询预先搭配好的记录 */
    func fetchPrepareDapeiId(dapeiDate: String) -> Int64 {
        let query = table_dapei.filter(t_dapei_date == dapeiDate && t_dapei_state == 0)
        do {
            //获取数据库连接
            db = try Connection(PATH_DATABASE_FILE)
            for dapei in try db.prepare(query) {
                return dapei[t_dapei_id]
            }
        } catch {
            print("获取预先搭配记录失败")
            print(error)
        }
        return -1
    }
}

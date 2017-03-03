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
    
    var dapeiID: String!
    var db: Connection!
    var dapeiDateStr: String!
    var day_air: Int!
    var night_air: Int!
    
    private let table_dapei_log = Table("Table_DaPei_Log")
    private let t_dp_log_id = Expression<Int>("id")
    private let t_dp_log_day_air = Expression<Int>("dapei_log_day_air")
    private let t_dp_log_night_air = Expression<Int>("dapei_log_night_air")
    private let t_dp_log_date = Expression<String>("dapei_log_date")
    private let t_dp_log_dpid = Expression<String>("dapei_log_dpid")
    
    func initTable() {
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(table_dapei_log.create(ifNotExists: true, block: { (t) in
                t.column(t_dp_log_id, primaryKey: true)
                t.column(t_dp_log_date, unique:true)
                t.column(t_dp_log_dpid)
                t.column(t_dp_log_day_air)
                t.column(t_dp_log_night_air)
            }))
        } catch {
            print("创建历史搭配日期表失败")
            print(error)
        }
    }

    func insert() -> Bool {
        let insert = table_dapei_log.insert(t_dp_log_date <- dapeiDateStr,
                                            t_dp_log_dpid <- dapeiID,
                                            t_dp_log_day_air <- day_air,
                                            t_dp_log_night_air <- night_air)
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
    
    func fetchDapeiModel(dateStr: String) -> ZJADapeiModel? {
        let query = table_dapei_log.filter(t_dp_log_date == dateStr)
        do {
            db = try Connection(PATH_DATABASE_FILE)
            for dapei in try db.prepare(query) {
                let dpId = dapei[t_dp_log_dpid]
                ZJATableDapei().fetchDapei(dpIdList: [dpId], block: { (models: [ZJADapeiModel]) in
                    
                })
                
            }
        } catch {
            print("从搭配记录表中根据时间获取搭配失败。")
            print(error)
        }
        return nil
    }
    
    func fetchDapeiList(dayAir: Int!, nightAir: Int!) -> [String]? {
        var dayAirList: Array<Int> = Array()
        dayAirList.append(dayAir)
        var nightAirList: Array<Int> = Array()
        nightAirList.append(nightAir)
        for i in 1 ..< 4 {
            dayAirList.append(dayAir-i)
            dayAirList.append(dayAir+i)
            nightAirList.append(nightAir-i)
            nightAirList.append(nightAir+i)
        }
        
        let query = table_dapei_log.filter(dayAirList.contains(t_dp_log_day_air) && nightAirList.contains(t_dp_log_night_air))
        do {
            //获取数据库连接
            db = try Connection(PATH_DATABASE_FILE)
            var dpList:[String] = []
            for dapei in try db.prepare(query) {
                dpList.append(dapei[t_dp_log_dpid])
            }
            return dpList
        } catch {
            print("根据早晚温度获取搭配记录列表失败")
            print(error)
        }
        return nil
    }
}

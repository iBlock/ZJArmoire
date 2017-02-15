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
    var clothesIdList: Array<String>!
    var dapei_date: String?
    var day_temperature: Int64?
    var night_temperature: Int64?
    
    //搭配记录表
    private let table_dapei = Table("Table_DaPei_List")
    private let t_dapei_id = Expression<Int64>("id")
    private let t_dapei_date = Expression<String?>("day_timer")
    private let t_dapei_day_air = Expression<Int64?>("day_air_temperature")
    private let t_dapei_night_air = Expression<Int64?>("night_air_temperature")
    //搭配次数
    private let t_dapei_count = Expression<Int64>("dapei_count")
    //dapei_state搭配状态，0：创建搭配 1：已使用搭配
    private let t_dapei_state = Expression<Int64>("dapei_state")
//    private let t_prepare_dapei_date = Expression<String>("prepare_dapei_date")
    
    func initTable() {
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(table_dapei.create(ifNotExists: true, block: { (t) in
                t.column(t_dapei_id, primaryKey: true)
                t.column(t_dapei_date)
                t.column(t_dapei_state, defaultValue: 0)
                t.column(t_dapei_count, defaultValue: 0)
                t.column(t_dapei_day_air)
                t.column(t_dapei_night_air)
            }))
        } catch {
            print("创建搭配记录表失败")
            print(error)
        }
    }
    
    func insert() -> Bool {
        let insert = table_dapei.insert(t_dapei_date <- dapei_date,
                                        t_dapei_day_air <- day_temperature,
                                        t_dapei_night_air <- night_temperature)
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
    
    func fetchDapei(dayTemp: Int64, nightTemp: Int64) -> Int64 {
        var dayAirList: Array<Int64> = Array()
        dayAirList.append(dayTemp)
        var nightAirList: Array<Int64> = Array()
        nightAirList.append(nightTemp)
        for i in 1 ..< 4 {
            dayAirList.append(dayTemp-i)
            dayAirList.append(dayTemp+i)
            nightAirList.append(nightTemp-i)
            nightAirList.append(nightTemp+i)
        }
        
        let query = table_dapei.filter(dayAirList.contains(t_dapei_day_air) && nightAirList.contains(t_dapei_night_air))
        do {
            //获取数据库连接
            db = try Connection(PATH_DATABASE_FILE)
            for dapei in try db.prepare(query) {
                return dapei[t_dapei_id]
            }
        } catch {
            print("根据早晚温度获取搭配记录失败")
            print(error)
        }
        return -1
    }
    
}

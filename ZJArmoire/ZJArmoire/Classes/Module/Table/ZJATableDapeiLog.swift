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
    var dpClothesList: String!
    
    private let table_dapei_log = Table("Table_DaPei_Log")
    private let t_dp_log_id = Expression<Int>("id")
    private let t_dp_log_day_air = Expression<Int>("dapei_log_day_air")
    private let t_dp_log_night_air = Expression<Int>("dapei_log_night_air")
    private let t_dp_log_date = Expression<String>("dapei_log_date")
    private let t_dp_log_dpid = Expression<String>("dapei_log_dpid")
    private let t_dp_log_dpclothes = Expression<String>("dapei_log_clotheslist")
    
    func initTable() {
        let query = table_dapei_log.create(ifNotExists: true, block: { (t) in
            t.column(t_dp_log_id, primaryKey: true)
            t.column(t_dp_log_date, unique:true)
            t.column(t_dp_log_dpid)
            t.column(t_dp_log_day_air)
            t.column(t_dp_log_night_air)
            t.column(t_dp_log_dpclothes)
        })
        let isSuccess = ZJASQLiteManager.default.runCreateDatabaseTable(querys: [query])
        if isSuccess == false {
            print("创建历史搭配日期表失败")
        }
    }

    func insert() -> Bool {
        let insert = table_dapei_log.insert(t_dp_log_date <- dapeiDateStr,
                                            t_dp_log_dpid <- dapeiID,
                                            t_dp_log_day_air <- day_air,
                                            t_dp_log_night_air <- night_air,
                                            t_dp_log_dpclothes <- dpClothesList)
        let isSuccess = ZJASQLiteManager.default.runUpdateDatabase(querys: [insert])
        if isSuccess == false {
            print("插入搭配记录表失败")
        }
        return isSuccess
    }
    
    func fetchDapeiModel(dateStr: String) -> ZJADapeiModel? {
        let query = table_dapei_log.filter(t_dp_log_date == dateStr)
        let sequnce = ZJASQLiteManager.default.runFetchDatabase(querys: [query])
        var dapeiModel: ZJADapeiModel?
        if let result = sequnce.first {
            for dapei in result {
                let dpId = dapei[t_dp_log_dpid]
                dapeiModel = ZJATableDapei().fetchDapei(dpId: dpId)
            }
        } else {
            print("从搭配记录表中根据时间获取搭配失败。\n")
        }
        return dapeiModel
    }
    
    func fetchDapeiList(dayAir: Int!, nightAir: Int!) -> [ZJADapeiModel] {
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
        let sequnce = ZJASQLiteManager.default.runFetchDatabase(querys: [query])
        var dpModels = [ZJADapeiModel]()
        if let result = sequnce.first {
            var dpidList = [String]()
            for dapei in result {
                dpidList.append(dapei[t_dp_log_dpid])
            }
            dpModels = ZJATableDapei().fetchDapeiList(dpIdList: dpidList)
        } else {
            print("根据早晚温度获取搭配记录列表失败")
        }
        return dpModels
    }
}

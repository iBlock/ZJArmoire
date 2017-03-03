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
    var dapei_date: String!
    var day_temperature: Int?
    var night_temperature: Int?
    var dapei_taglist: Array<String>?
    
    //搭配记录表
    private let table_dapei = Table("Table_DaPei_List")
    private let t_dapei_id = Expression<String>("id")
    private let t_dapei_date = Expression<String>("day_timer")
    private let t_dapei_day_air = Expression<Int?>("day_air_temperature")
    private let t_dapei_night_air = Expression<Int?>("night_air_temperature")
    private let t_dapei_taglist = Expression<String?>("dapei_taglist")
    ///搭配衣服ID列表，格式: 372382332837,82382938283
    private let t_dapei_clotheslist = Expression<String>("dapei_clotheslist")
    ///历史搭配温度记录，格式：10-23:9-18
    private let t_dapei_history_air = Expression<String>("history_air")
    //使用搭配次数
//    private let t_dapei_count = Expression<Int>("dapei_count")
    //dapei_state搭配状态，0：创建搭配 1：已使用搭配
//    private let t_dapei_state = Expression<Int>("dapei_state")
//    private let t_prepare_dapei_date = Expression<String>("prepare_dapei_date")
    
    func initTable() {
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(table_dapei.create(ifNotExists: true, block: { (t) in
                t.column(t_dapei_id, primaryKey: true)
                t.column(t_dapei_date)
//                t.column(t_dapei_state, defaultValue: 0)
//                t.column(t_dapei_count, defaultValue: 0)
                t.column(t_dapei_day_air)
                t.column(t_dapei_night_air)
                t.column(t_dapei_taglist)
                t.column(t_dapei_clotheslist)
                t.column(t_dapei_history_air, defaultValue: "")
            }))
        } catch {
            print("创建搭配记录表失败")
            print(error)
        }
    }
    
    func insert() -> Bool {
        var dpTaglistStr: String?
        if let dpTaglist = dapei_taglist {
            dpTaglistStr = dpTaglist.joined(separator: ",")
        }
        let clothesIdStr = clothesIdList.joined(separator: ",")
        let uuid = String.generateUUID()
        let insert = table_dapei.insert(t_dapei_id <- uuid,
                                        t_dapei_date <- dapei_date,
                                        t_dapei_clotheslist <- clothesIdStr,
                                        t_dapei_day_air <- day_temperature,
                                        t_dapei_night_air <- night_temperature,
                                        t_dapei_taglist <- dpTaglistStr)
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try self.db.run(insert)
            _ = syncDapei_ClothesTable(dapeiID: uuid)
            return true
        } catch {
            print("插入搭配记录表失败")
            print(error)
            return false
        }
    }
    
    /// 根据时间查询预先搭配好的记录
    func fetchPrepareDapeiId(dapeiDate: String) -> String? {
        let query = table_dapei.filter(t_dapei_date == dapeiDate)
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
        return nil
    }
    
    /// 根据搭配ID列表获取搭配
    func fetchDapei(dpIdList: [String], block: @escaping ([ZJADapeiModel])->Void) {
        DispatchQueue.global().async {
            var dapeiList = [ZJADapeiModel]()
            do {
                self.db = try Connection(PATH_DATABASE_FILE)
                for dpId in dpIdList {
                    let query = self.table_dapei.filter(self.t_dapei_id == dpId)
                    for dapei in try self.db.prepare(query) {
                        dapeiList.append(self.buildDapeiModel(dapei: dapei))
                        break
                    }
                }
            } catch {
                print("根据搭配ID列表获取搭配失败。")
                print(error)
            }
            DispatchQueue.main.async {
                block(dapeiList)
            }
        }
        
    }
    
    /// 获取数据库所有搭配
    func fetchAllDapei(block:@escaping ([ZJADapeiModel])->Void) {
        var dapeiList = [ZJADapeiModel]()
        ZJASQLiteManager.default.runFetchDatabase(query: table_dapei) { (isSuccess, result) in
            if isSuccess == true {
                if let list = result {
                    for dapei in list {
                        dapeiList.append(self.buildDapeiModel(dapei: dapei))
                    }
                }
            }
        }
        DispatchQueue.global().async {
            var dapeiList = [ZJADapeiModel]()
            do {
                self.db = try Connection(PATH_DATABASE_FILE)
                for dapei in try self.db.prepare(self.table_dapei) {
                    dapeiList.append(self.buildDapeiModel(dapei: dapei))
                }
            } catch {
                print("获取搭配列表失败。")
                print(error)
            }
            DispatchQueue.main.async {
                block(dapeiList)
            }
        }
    }
    
    func buildDapeiModel(dapei: Row) -> ZJADapeiModel {
        let model = ZJADapeiModel()
        model.dapei_id = dapei[t_dapei_id]
        model.dapei_time = dapei[t_dapei_date]
        model.day_temp = dapei[t_dapei_day_air]
        model.night_temp = dapei[t_dapei_night_air]
        let taglistStr = dapei[t_dapei_taglist]
        model.taglist = taglistStr?.components(separatedBy: ",")
        let clothesList = dapei[t_dapei_clotheslist]
        ZJATableDapei_Clothes().fetchDapeiDetail(clothesIdList: clothesList.components(separatedBy: ",")) { (clothesModels) in
            model.clothesList = clothesModels
        }
//        model.clothesList = ZJATableDapei_Clothes().fetchDapeiDetail(clothesIdList: clothesList.components(separatedBy: ","))
        model.history_air = dapei[t_dapei_history_air]
        return model
    }
    
}

extension ZJATableDapei {
    /// 同步搭配与衣服的关联表
    func syncDapei_ClothesTable(dapeiID: String) -> Bool {
        let table = ZJATableDapei_Clothes()
        table.dapei_id = dapeiID
        let isSuccess = table.insert(clothesIdList: clothesIdList)
        return isSuccess
    }
}

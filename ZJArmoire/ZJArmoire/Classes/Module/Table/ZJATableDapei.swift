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
    
    var clothesIdList: Array<String>!
    var dapei_date: String!
    var dapei_taglist: Array<String>?
    
    //搭配记录表
    private let table_dapei = Table("Table_DaPei_List")
    private let t_dapei_id = Expression<String>("id")
    private let t_dapei_date = Expression<String>("day_timer")
    private let t_dapei_taglist = Expression<String?>("dapei_taglist")
    ///搭配衣服ID列表，格式: 372382332837,82382938283
    private let t_dapei_clotheslist = Expression<String>("dapei_clotheslist")
    
    func initTable() {
        let query = table_dapei.create(ifNotExists: true, block: { (t) in
            t.column(t_dapei_id, primaryKey: true)
            t.column(t_dapei_date)
            t.column(t_dapei_taglist)
            t.column(t_dapei_clotheslist)
        })
        let isSuccess = ZJASQLiteManager.default.runCreateDatabaseTable(querys: [query])
        if isSuccess == false {
            print("创建搭配记录表失败")
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
                                        t_dapei_taglist <- dpTaglistStr)
        let isSuccess = ZJASQLiteManager.default.runInsertDatabase(querys: [insert])
        if isSuccess == true {
            syncDapei_ClothesTable(dapeiID: uuid)
        } else {
            print("插入搭配记录表失败")
        }
        
        return isSuccess
    }
    
    /// 根据搭配ID获取搭配数据
    func fetchDapei(dpId: String) -> ZJADapeiModel? {
        let query = table_dapei.filter(t_dapei_id == dpId)
        var dpModel: ZJADapeiModel?
        let sequnce = ZJASQLiteManager.default.runFetchDatabase(querys: [query])
        if let result = sequnce.first {
            for dp in result {
                dpModel = buildDapeiModel(dapei: dp)
                break
            }
        } else {
            print("根据搭配ID获取搭配失败。\n")
        }
        return dpModel
    }
    
    /// 根据搭配ID删除搭配
    func deleteDapei(dpIdList: [String]) -> Bool {
        var querys: [Delete] = [Delete]()
        for dpId in dpIdList {
            let query = table_dapei.filter(t_dapei_id == dpId)
            querys.append(query.delete())
        }
        let isSuccess = ZJASQLiteManager.default.runDeleteDatabase(querys: querys)
        if isSuccess == false {
            print("搭配ID为：" + dpIdList.joined(separator: ",") + "的搭配删除失败")
        } else {
            // 删除搭配后更新搭配列表
            NotificationCenter.default.post(name: Notification.Name(KEY_NOTIFICATION_UPDATE_DAPEI_LIST), object: nil)
        }
        return isSuccess
    }
    
    /// 根据搭配ID列表获取搭配
    func fetchDapeiList(dpIdList: [String]) -> [ZJADapeiModel] {
        var dapeiList = [ZJADapeiModel]()
        var querys: [QueryType] = [QueryType]()
        for dpId in dpIdList {
            let query = table_dapei.filter(t_dapei_id == dpId)
            querys.append(query)
        }
        
        let sequensList = ZJASQLiteManager.default.runFetchDatabase(querys: querys)
        for sequens in sequensList {
            for result in sequens {
                if let model = buildDapeiModel(dapei: result) {
                    dapeiList.append(model)
                }
                break
            }
        }
        return dapeiList
    }
    
    /// 获取数据库所有搭配
    func fetchAllDapei() -> [ZJADapeiModel] {
        var dapeiList = [ZJADapeiModel]()
        let result = ZJASQLiteManager.default.runFetchDatabase(querys: [table_dapei])
        if let list = result.first {
            for dapei in list {
                if let model = buildDapeiModel(dapei: dapei) {
                    dapeiList.append(model)
                }
            }
        } else {
            print("获取搭配列表失败。")
        }
        return dapeiList
    }
    
    /// 构造搭配模型
    func buildDapeiModel(dapei: Row) -> ZJADapeiModel? {
        let clothesList = dapei[t_dapei_clotheslist]
        let clothesModels = ZJATableClothes().fetchClothes(clothesIdList: clothesList.components(separatedBy: ","))
        if clothesModels.count == 0 {
            // 如果该搭配的衣服都已经删除了，那么该条搭配记录也没意义了，删除
            _ = self.deleteDapei(dpIdList: [dapei[t_dapei_id]])
            return nil
        }
        let model = ZJADapeiModel()
        model.dapei_id = dapei[t_dapei_id]
        model.dapei_time = dapei[t_dapei_date]
        let taglistStr = dapei[t_dapei_taglist]
        model.taglist = taglistStr?.components(separatedBy: ",")
        model.clothesList = clothesModels
        model.clothesIdList = clothesList.components(separatedBy: ",")
        
        return model
    }
}

extension ZJATableDapei {
    /// 同步搭配与衣服的关联表
    func syncDapei_ClothesTable(dapeiID: String) {
        let table = ZJATableDapei_Clothes()
        table.dapei_id = dapeiID
        let isSuccess = table.insert(clothesIdList: clothesIdList)
        if isSuccess == false {
            print("同步搭配与衣服的关联失败\n")
        }
    }
}

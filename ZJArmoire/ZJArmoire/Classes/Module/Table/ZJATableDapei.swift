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
        let isSuccess = ZJASQLiteManager.default.runUpdateDatabase(querys: [insert])
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
                dapeiList.append(buildDapeiModel(dapei: result))
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
                dapeiList.append(buildDapeiModel(dapei: dapei))
            }
        } else {
            print("获取搭配列表失败。")
        }
        return dapeiList
    }
    
    /// 构造搭配模型
    func buildDapeiModel(dapei: Row) -> ZJADapeiModel {
        let clothesList = dapei[t_dapei_clotheslist]
        let clothesModels = ZJATableClothes().fetchClothes(clothesIdList: clothesList.components(separatedBy: ","))
        let model = ZJADapeiModel()
        model.dapei_id = dapei[t_dapei_id]
        model.dapei_time = dapei[t_dapei_date]
        let taglistStr = dapei[t_dapei_taglist]
        model.taglist = taglistStr?.components(separatedBy: ",")
        model.clothesList = clothesModels
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

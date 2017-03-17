//
//  ZJATableDapei_Clothes.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/2/12.
//  Copyright © 2017年 iBlock. All rights reserved.
//  衣服和搭配记录的关联表

import Foundation
import SQLite

class ZJATableDapei_Clothes: NSObject {
    var clothes_id: String!
    var dapei_id: String!
    
    private let table_dapei_clothes = Table("Table_Clothes_Dapei")
    private let t_yf_dp_id = Expression<Int>("id")
    private let t_yf_dp_yf_id = Expression<String>("clothes_id")
    private let t_yf_dp_dp_id = Expression<String>("dapei_id")
    
    func initTable() {
        let query1 = table_dapei_clothes.create(ifNotExists: true, block: { (t) in
            t.column(t_yf_dp_id, primaryKey: true)
            t.column(t_yf_dp_yf_id)
            t.column(t_yf_dp_dp_id)
        })
        let query2 = table_dapei_clothes.createIndex([t_yf_dp_yf_id, t_yf_dp_dp_id], unique: true, ifNotExists: true)
        let isSuccess = ZJASQLiteManager.default.runCreateDatabaseTable(querys: [query1,query2])
        if isSuccess == false {
            print("创建衣服和搭配记录的关联表失败")
        }
    }
    
    /// 插入衣服和搭配关联表
    func insert(clothesIdList: Array<String>) -> Bool {
    var insertList: [Insert] = [Insert]()
        for clothesid in clothesIdList {
            let insert = self.table_dapei_clothes.insert(
                t_yf_dp_yf_id <- clothesid,
                t_yf_dp_dp_id <- dapei_id)
            insertList.append(insert)
        }
        let isSuccess = ZJASQLiteManager.default.runInsertDatabase(querys: insertList)
        if isSuccess == false {
            print("插入衣服和搭配关联表失败")
        }
        return isSuccess
    }
    
    /// 根据搭配ID获取搭配衣服列表
    func fetchDapeiDetail(dapeiID: String) -> [ZJAClothesModel] {
        let sql = table_dapei_clothes.filter(t_yf_dp_dp_id == dapeiID)
        let dapeiClothesList = [ZJAClothesModel]()
        var clothesIdList = [String]()
        let sequence = ZJASQLiteManager.default.runFetchDatabase(querys: [sql])
        if let result = sequence.first {
            for dp in result {
                let clothesID = dp[self.t_yf_dp_yf_id]
                clothesIdList.append(clothesID)
            }
            let models = ZJATableClothes().fetchClothes(clothesIdList: clothesIdList)
            return models
        } else {
            print("获取搭配详情记录失败。")
        }
        return dapeiClothesList
    }
    
}

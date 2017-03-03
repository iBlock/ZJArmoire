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
    var db: Connection!
    var clothes_id: String!
    var dapei_id: String!
    
    private let table_dapei_clothes = Table("Table_Clothes_Dapei")
    private let t_yf_dp_id = Expression<Int>("id")
    private let t_yf_dp_yf_id = Expression<String>("clothes_id")
    private let t_yf_dp_dp_id = Expression<String>("dapei_id")
    
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
    
    func insert(clothesIdList: Array<String>) -> Bool {
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.transaction {
                for clothesid in clothesIdList {
                    try self.db.run(
                        self.table_dapei_clothes.insert(self.t_yf_dp_yf_id <- clothesid,
                                                        self.t_yf_dp_dp_id <- self.dapei_id))
                }
            }
            return true
        } catch {
            print("插入衣服和搭配关联表失败")
            print(error)
            return false
        }
    }
    
    func fetchDapeiDetail(clothesIdList: [String],
                          callback:([ZJAClothesModel])->Void) {
        var dapeiClothesList = [ZJAClothesModel]()
        do {
            db = try Connection(PATH_DATABASE_FILE)
            for clothesID in clothesIdList {
                if let clothes = ZJATableClothes().fetchClothes(clothesID) {
                    dapeiClothesList.append(clothes)
                }
            }
        } catch {
            print("获取搭配详情记录失败。")
            print(error)
        }
        callback(dapeiClothesList)
    }
    
    func fetchDapeiDetail(dapeiID: String) -> [ZJAClothesModel] {
        let sql = table_dapei_clothes.filter(t_yf_dp_dp_id == dapeiID)
        var dapeiClothesList = [ZJAClothesModel]()
        do {
            db = try Connection(PATH_DATABASE_FILE)
            for dp in try db.prepare(sql) {
                let clothesID = dp[t_yf_dp_yf_id]
                if let clothes = ZJATableClothes().fetchClothes(clothesID) {
                    dapeiClothesList.append(clothes)
                }
            }
        } catch {
            print("获取搭配详情记录失败。")
            print(error)
        }
        return dapeiClothesList
    }
    
}

//
//  ZJATableClothes.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/1/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit
import SQLite

class ZJATableClothes: NSObject {
    
    var uuid: String!
    var category: Int!
    var photoName: String!
    var tagList: String?
    var day_air: Int?
    var night_air: Int?
    
    var db: Connection!
    
    //衣服表
    private let table_clothes = Table("Table_Clothes_List")
    private let t_clothes_id = Expression<Int>("id")
    private let t_clothes_uuid = Expression<String>("uuid")
    private let t_clothes_type = Expression<Int>("type")
    private let t_clothes_photo_name = Expression<String>("photo_name")
    private let t_clothes_tags = Expression<String?>("tag_list")
    private let t_clothes_day_air = Expression<Int?>("day_air_temperature")
    private let t_clothes_night_air = Expression<Int?>("night_air_temperature")
    
    override init() {
        super.init()
    }
    
    init(model: ZJAClothesModel) {
        super.init()
        uuid = model.uuid
        category = model.type
        tagList = model.tags
        day_air = model.day_air
        night_air = model.night_air
    }
    
    func initTable() {
        let query = table_clothes.create(ifNotExists: true, block: { (t) in
            t.column(t_clothes_id, primaryKey: true)
            t.column(t_clothes_uuid, unique: true)
            t.column(t_clothes_type)
            t.column(t_clothes_photo_name)
            t.column(t_clothes_tags)
            t.column(t_clothes_day_air)
            t.column(t_clothes_night_air)
        })

        let isSuccess = ZJASQLiteManager.default.runCreateDatabaseTable(querys: [query])
        if isSuccess == false {
            print("创建衣服表失败")
        }
    }
    
    //插入数据
    func insert() -> Bool {
        //表结构设定
        let insert = table_clothes.insert(
            t_clothes_uuid <- uuid,
            t_clothes_type <- category,
            t_clothes_photo_name <- photoName,
            t_clothes_tags <- tagList
            )
        return ZJASQLiteManager.default.runInsertDatabase(querys: [insert])
    }
    
    //根据衣服ID更新数据
    func update(_ uuid: String) -> Bool {
        let alice = table_clothes.filter(t_clothes_uuid == uuid)
        let sql = alice.update(t_clothes_type <- category,
                               t_clothes_tags <- tagList,
                               t_clothes_day_air <- day_air,
                               t_clothes_night_air <- night_air
        )
        
        let isSuccess = ZJASQLiteManager.default.runUpdateDatabase(querys: [sql])
        if isSuccess == false {
            print("uuid = " + uuid + " 的衣服更新失败")
        }
        return isSuccess
    }
    
    /// 根据衣服ID获取衣服数据
    func fetchClothes(_ uuid: String) -> ZJAClothesModel? {
        let query = table_clothes.filter(t_clothes_uuid == uuid)
        let result = ZJASQLiteManager.default.runFetchDatabase(querys: [query])
        var model: ZJAClothesModel?
        if let quece = result.first {
            for clothes in quece {
                model = self.buildClothesModel(clothes: clothes)
                break
            }
        } else {
            print("根据指定uuid获取衣服失败。")
        }
        return model
    }
    
    /// 根据衣服ID列表批量获取衣服
    func fetchClothes(clothesIdList: [String]) -> [ZJAClothesModel] {
        var dapeiClothesList = [ZJAClothesModel]()
        var queryList: [QueryType] = [QueryType]()
        for clothesID in clothesIdList {
            let query = table_clothes.filter(t_clothes_uuid == clothesID)
            queryList.append(query)
        }
        let sequenceList = ZJASQLiteManager.default.runFetchDatabase(querys: queryList)
        for sequence in sequenceList {
            for clothes in sequence {
                let model = self.buildClothesModel(clothes: clothes)
                dapeiClothesList.append(model)
                break
            }
        }
        return dapeiClothesList
    }
    
    //获取指定类型的衣服
    func fetchAllClothes(_ type: NSInteger) -> [ZJAClothesModel] {
        let query = self.table_clothes.filter(self.t_clothes_type == type)
        let sequence = ZJASQLiteManager.default.runFetchDatabase(querys: [query])
        var allClothes = [ZJAClothesModel]()
        if let result = sequence.first {
            for clothes in result {
                let model = ZJAClothesModel()
                let imagePath = PATH_PHOTO_IMAGE + clothes[self.t_clothes_photo_name]
                model.type = clothes[self.t_clothes_type]
                model.uuid = clothes[self.t_clothes_uuid]
                model.tags = clothes[self.t_clothes_tags]
                if let image = UIImage(contentsOfFile: imagePath) {
                    model.clothesImg = image
                } else {
                    model.clothesImg = UIImage()
                    print("%s图片找不到了",clothes[self.t_clothes_photo_name])
                }
                allClothes.append(model)
            }
        }else {
            print("获取指定类型的衣服失败。")
        }
        return allClothes
    }
    
    func buildClothesModel(clothes: Row) -> ZJAClothesModel {
        let model = ZJAClothesModel()
        let imagePath = PATH_PHOTO_IMAGE + clothes[self.t_clothes_photo_name]
        model.type = clothes[self.t_clothes_type]
        model.uuid = clothes[self.t_clothes_uuid]
        model.tags = clothes[self.t_clothes_tags]
        if let image = UIImage(contentsOfFile: imagePath) {
            model.clothesImg = image
        } else {
            model.clothesImg = UIImage()
            print("%s图片找不到了",clothes[self.t_clothes_photo_name])
        }
        return model
    }
}

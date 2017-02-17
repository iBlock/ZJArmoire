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
    var category: NSInteger!
    var photoName: String!
    var tagList: String?
    
    var db: Connection!
    
    //衣服表
    private let table_clothes = Table("Table_Clothes_List")
    private let t_clothes_id = Expression<Int64>("id")
    private let t_clothes_uuid = Expression<String>("uuid")
    private let t_clothes_type = Expression<Int64>("type")
    private let t_clothes_photo_name = Expression<String>("photo_name")
    private let t_clothes_tags = Expression<String?>("tag_list")
    private let t_clothes_day_air = Expression<Int64?>("day_air_temperature")
    private let t_clothes_night_air = Expression<Int64?>("night_air_temperature")
    
    func initTable() {
        do{
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(table_clothes.create(ifNotExists: true, block: { (t) in
                t.column(t_clothes_id, primaryKey: true)
                t.column(t_clothes_uuid, unique: true)
                t.column(t_clothes_type)
                t.column(t_clothes_photo_name)
                t.column(t_clothes_tags)
                t.column(t_clothes_day_air)
                t.column(t_clothes_night_air)
            }))
        } catch {
            print("创建衣服表失败")
            print(error)
        }
    }
    
    //插入数据
    func insert() -> Bool {
        //表结构设定
        let insert = table_clothes.insert(
            t_clothes_uuid <- uuid,
            t_clothes_type <- Int64(category!),
            t_clothes_photo_name <- photoName,
            t_clothes_tags <- tagList
            )
        do {
            //连接数据库
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(insert)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    //获取指定类型的衣服
    func fetchAllClothes(_ type: NSInteger, block:@escaping (([ZJAClothesModel])->Void)) {
        DispatchQueue.global().async {
            var allClothes = [ZJAClothesModel]()
            //指定查询条件
            let query = self.table_clothes.filter(self.t_clothes_type == Int64(type))
            do {
                //获取数据库连接
                self.db = try Connection(PATH_DATABASE_FILE)
                for clothes in try self.db.prepare(query) {
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
            } catch {
                print("创建衣服表失败")
                print(error)
            }
            DispatchQueue.main.async {
                block(allClothes)
            }
        }
    }
    
}

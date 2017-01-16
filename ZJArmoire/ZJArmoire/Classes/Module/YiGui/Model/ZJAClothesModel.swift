//
//  ZJAClothesModel.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/1/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import UIKit
import SQLite

class ZJAClothesModel: NSObject {
    
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
            try db.run(table_clothes.create(ifNotExists: false, block: { (t) in
                t.column(t_clothes_id, primaryKey: true)
                t.column(t_clothes_uuid, unique: true)
                t.column(t_clothes_type)
                t.column(t_clothes_photo_name)
                t.column(t_clothes_tags)
                t.column(t_clothes_day_air)
                t.column(t_clothes_night_air)
            }))
        } catch { print(error) }
    }
    
    func insert() -> Bool {
        let insert = table_clothes.insert(
            t_clothes_uuid <- uuid,
            t_clothes_type <- Int64(category!),
            t_clothes_photo_name <- photoName,
            t_clothes_tags <- tagList
            )
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(insert)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func fetchAllClothes(_ type: NSInteger) -> [UIImage]? {
        var allClothes = [UIImage]()
        let query = table_clothes.filter(t_clothes_type == Int64(type))
        do {
            db = try Connection(PATH_DATABASE_FILE)
            for clothes in try db.prepare(query) {
                let imagePath = PATH_PHOTO_IMAGE + clothes[t_clothes_photo_name]
                if let image = UIImage(contentsOfFile: imagePath) {
                    allClothes.append(image)
                } else {
                    print("%s图片找不到了",clothes[t_clothes_photo_name])
                }
            }
        } catch {
            print(error)
        }
        
        return allClothes
    }
    
}

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
    
    var category: NSInteger!
    var photoName: String!
    
    var db: Connection!
    
    //衣服表
    private let table_clothes = Table("Table_Clothes_List")
    private let t_clothes_id = Expression<Int64>("id")
    private let t_clothes_type = Expression<Int64>("type")
    private let t_clothes_photo_name = Expression<String>("photo_name")
    private let t_clothes_day_air = Expression<Int64?>("day_air_temperature")
    private let t_clothes_night_air = Expression<Int64?>("night_air_temperature")
    
    func initTable() {
        do{
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(table_clothes.create(ifNotExists: false, block: { (t) in
                t.column(t_clothes_id, primaryKey: true)
                t.column(t_clothes_type)
                t.column(t_clothes_photo_name)
                t.column(t_clothes_day_air)
                t.column(t_clothes_night_air)
            }))
        } catch { }
    }
    
    func insert() -> Bool {
        let insert = table_clothes.insert(
            t_clothes_type <- Int64(category!),
            t_clothes_photo_name <- photoName
            )
        do {
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(insert)
            return true
        } catch {
            return false
        }
    }
    
}

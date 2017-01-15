//
//  ZJASQLiteManager.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/1/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation
import SQLite

struct ZJASQLiteManager {
    private var db: Connection!
    
    //标签表
    private let table_tag = Table("Table_Tag_List")
    private let t_tag_id = Expression<Int64>("id")
    private let t_tag_name = Expression<String>("tag_name")
    
    //搭配记录表
    private let table_dapei = Table("Table_DaPei_List")
    private let t_dapei_id = Expression<Int64>("id")
    private let t_dapei_date = Expression<Int64>("day_timer")
    private let t_dapei_day_air = Expression<Int64>("day_air_temperature")
    private let t_dapei_night_air = Expression<Int64>("night_air_temperature")
    
    //衣服和标签的关联表
    private let table_clothes_tag = Table("Table_Clothes_Tag")
    private let t_yf_tag_id = Expression<Int64>("id")
    private let t_yf_tag_clothes_id = Expression<Int64>("clothes_id")
    private let t_yf_tag_tag_id = Expression<Int64>("tag_id")
    
    //衣服和搭配记录的关联表
    private let table_dapei_clothes = Table("Table_Clothes_Dapei")
    private let t_yf_dp_id = Expression<Int64>("id")
    private let t_yf_dp_yf_id = Expression<Int64>("clothes_id")
    private let t_yf_dp_dp_id = Expression<Int64>("dapei_id")
    
    init() {
        createdsqlite3()
    }
    
    //创建数据库文件
    mutating func createdsqlite3(filePath: String = "/Documents")  {
        do {
            ZJAClothesModel().initTable()
            db = try Connection(PATH_DATABASE_FILE)
            try db.run(table_tag.create(block: { (t) in
                t.column(t_tag_id, primaryKey: true)
                t.column(t_tag_name)
            }))
            
            try db.run(table_dapei.create(block: { (t) in
                t.column(t_dapei_id, primaryKey: true)
                t.column(t_dapei_date)
                t.column(t_dapei_day_air)
                t.column(t_dapei_night_air)
            }))
            
            try db.run(table_clothes_tag.create(block: { (t) in
                t.column(t_yf_dp_id, primaryKey: true)
                t.column(t_yf_tag_clothes_id)
                t.column(t_yf_tag_tag_id)
            }))
            
            try db.run(table_dapei_clothes.create(block: { (t) in
                t.column(t_yf_dp_id, primaryKey: true)
                t.column(t_yf_dp_yf_id)
                t.column(t_yf_dp_dp_id)
            }))
        } catch {  }
    }
    
}

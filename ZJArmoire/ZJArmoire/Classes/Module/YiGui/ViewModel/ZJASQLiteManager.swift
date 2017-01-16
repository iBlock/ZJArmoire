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
    

    
    //搭配记录表
    private let table_dapei = Table("Table_DaPei_List")
    private let t_dapei_id = Expression<Int64>("id")
    private let t_dapei_date = Expression<Int64>("day_timer")
    private let t_dapei_day_air = Expression<Int64>("day_air_temperature")
    private let t_dapei_night_air = Expression<Int64>("night_air_temperature")
    
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
            ZJATagsModel().initTable()
            ZJAClothesTagTable().initTable()
            db = try Connection(PATH_DATABASE_FILE)
            
            try db.run(table_dapei.create(block: { (t) in
                t.column(t_dapei_id, primaryKey: true)
                t.column(t_dapei_date)
                t.column(t_dapei_day_air)
                t.column(t_dapei_night_air)
            }))
            
            try db.run(table_dapei_clothes.create(block: { (t) in
                t.column(t_yf_dp_id, primaryKey: true)
                t.column(t_yf_dp_yf_id)
                t.column(t_yf_dp_dp_id)
            }))
        } catch {  }
    }
    
}

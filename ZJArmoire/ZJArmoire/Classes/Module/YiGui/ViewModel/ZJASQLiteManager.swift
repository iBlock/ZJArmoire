//
//  ZJASQLiteManager.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/1/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation
import SQLite

class ZJASQLiteManager: NSObject {
    
    var db: Connection!
    static let `default` = ZJASQLiteManager()
    let serialDispatchQueue = DispatchQueue(label: "cn.iblock.ZJASQLiteManagerQueue")
    
    override init() {
        super.init()
        do {
            self.db = try Connection(PATH_DATABASE_FILE)
        } catch {
            print("!!!!!!!!!!!!!!!!!连接数据库失败\n")
        }
    }
    
    /// 数据库统一创建表格方法
    public func runCreateDatabaseTable(querys: [String]) -> Bool {
        var isSuccess = false
        do {
            try db.transaction {
                for query in querys {
                    try self.db.run(query)
                }
            }
            isSuccess = true
        } catch {
            print(error)
        }
        return isSuccess
    }
    
    /// 数据库统一更新事务
    public func runUpdateDatabase(querys: [Expressible]) -> Bool {
        var isSuccess = false
        do {
            try self.db.transaction {
                for query in querys {
                    try self.db.run(query.expression.template,
                                    query.expression.bindings)
                }
            }
            isSuccess = true
        } catch {
            isSuccess = false
            print("!!!!!!!!!!!!!!!!数据库写入出错了，快来看看吧\n")
            print(error)
        }
        return isSuccess
    }
    
    /// 数据库统一查询方法
    public func runFetchDatabase(querys: [QueryType]) -> [AnySequence<Row>] {
        var result: [AnySequence<Row>] = [AnySequence<Row>]()
        do {
            for query in querys {
                let sequence = try self.db.prepare(query)
                result.append(sequence)
            }
        } catch {
            print("!!!!!!!!!!!!!!!!数据库读取出错了，快来看看吧\n")
            print(error)
        }
        return result
    }
    
    //创建数据库文件
    public func createdsqlite3()  {
        ZJATableClothes().initTable()
        ZJATableTags().initTable()
        ZJATableClothes_Tag().initTable()
        ZJATableDapei().initTable()
        ZJATableDapei_Clothes().initTable()
    }
}

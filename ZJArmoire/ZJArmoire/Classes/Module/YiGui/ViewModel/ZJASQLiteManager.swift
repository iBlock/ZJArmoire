//
//  ZJASQLiteManager.swift
//  ZJArmoire
//
//  Created by iBlock on 2017/1/15.
//  Copyright © 2017年 iBlock. All rights reserved.
//

import Foundation
import SQLite

typealias InsertCallback = (Bool) -> Void

typealias ZJADatabaseUpdateBlock = (Bool!) -> Void
typealias ZJADatabaseInitBlock = (Bool) -> Void
typealias ZJADatabaseFetchResultBlock = (Bool,AnySequence<Row>?) -> Void

@objc protocol ZJASQLiteProtocol {
//    func initTable()
//    func insert()
}

class ZJASQLiteManager: NSObject {
    
    var db: Connection!
    static let `default` = ZJASQLiteManager()
    let serialDispatchQueue = DispatchQueue(label: "cn.iblock.ZJASQLiteManagerQueue")
    
    override init() {
        super.init()
        createdsqlite3()
    }
    
    /// 数据库统一更新事务
    public func runUpdateDatabase(querys: [Expressible], block: @escaping ZJADatabaseUpdateBlock) {
        serialDispatchQueue.sync {
            var isSuccess = false
            do {
                self.db = try Connection(PATH_DATABASE_FILE)
                try self.db.transaction {
                    for query in querys {
                        try self.db.run(query.expression.template, query.expression.bindings)
                    }
                }
                isSuccess = true
            } catch {
                isSuccess = false
                print("!!!!!!!!!!!!!!!!数据库写入出错了，快来看看吧")
                print(error)
            }
            
            DispatchQueue.main.async {
                block(isSuccess)
            }
        }
    }
    
    /// 数据库统一查询方法
    public func runFetchDatabase(query: QueryType,
                                 block: @escaping ZJADatabaseFetchResultBlock) {
        serialDispatchQueue.async {
            var isSuccess = false
            var result: AnySequence<Row>?
            do {
                self.db = try Connection(PATH_DATABASE_FILE)
                result = try self.db.prepare(query)
                isSuccess = true
            } catch {
                isSuccess = false
                print("!!!!!!!!!!!!!!!!数据库读取出错了，快来看看吧\n")
                print(error)
            }
            DispatchQueue.main.async {
                block(isSuccess, result)
            }
        }
    }
    
    //创建数据库文件
    private func createdsqlite3()  {
        ZJATableClothes().initTable()
        ZJATableTags().initTable()
        ZJATableClothes_Tag().initTable()
        ZJATableDapei().initTable()
        ZJATableDapei_Clothes().initTable()
    }
}

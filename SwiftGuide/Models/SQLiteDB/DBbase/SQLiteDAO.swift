//
//  SQLiteDAO.swift
//  SwiftGuide
//
//  Created by 王庭謙 on 2020/10/5.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import SQLite3
import Foundation

class SQLiteDAO<Table: DBbaseEnum> {
    
    var db: OpaquePointer?
    
    init() {
        // 搜尋資料庫路徑
        let target = "\(NSHomeDirectory())/Documents/CompanyDB.sqlite"
        if !FileManager.default.fileExists(atPath: target) {
            let source = Bundle.main.path(forResource: "CompanyDB", ofType: ".sqlite")!
            try? FileManager.default.copyItem(atPath: source, toPath: target)
        }
        // 開啟資料庫連線
        if sqlite3_open(target, &db) == SQLITE_OK {
            print("成功連線")
        } else {
            print("連線失敗")
        }
        print("連線路徑：\(target)")
    }
    
    func insert(_ entity: [String:String]) {
        var statement: OpaquePointer? = nil
        let sqlCmd = "INSERT INTO \(Table.tableName) "
        + "(\(Table.allCases.map { $0.rawValue as! String }.joined(separator: ", "))) "
        + "VALUES (\(Table.allCases.map {"'\(entity[$0.rawValue as! String] ?? "")'"}.joined(separator: ", ")))"
        
        if sqlite3_prepare_v2(db, sqlCmd.cString(using: String.Encoding.utf8), -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table \(Table.tableName) 新增資料成功")
            }
        }
        sqlite3_finalize(statement)
    }
    
    func delete(_ entity: [String:String]) {
        var statement :OpaquePointer? = nil
        let sqlCmd = "DELETE FROM \(Table.tableName) "
        + "WHERE \(entity.map { "\($0.key) = '\($0.value)'" }.joined(separator: " AND "))"
        
        if sqlite3_prepare_v2(self.db, sqlCmd.cString(using: String.Encoding.utf8), -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table \(Table.tableName) 刪除資料成功")
            }
        }
        sqlite3_finalize(statement)
    }
    
    func update(_ filter: [String:String], _ entity: [String:String]) {
        var statement: OpaquePointer? = nil
        let sqlCmd = "UPDATE \(Table.tableName) "
        + "SET \(entity.map { "\($0.key) = '\($0.value)'" }.joined(separator: ", ")) "
        + "WHERE (\(filter.map { "\($0.key) = '\($0.value)'" }.joined(separator: " AND ")))"
        
        if sqlite3_prepare_v2(db, sqlCmd.cString(using: String.Encoding.utf8), -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table \(Table.tableName) 更新資料成功")
            }
        }
        sqlite3_finalize(statement)
    }
    
    func select() {}
}

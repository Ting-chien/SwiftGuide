//
//  SQLiteDAO.swift
//  SwiftGuide
//
//  Created by 王庭謙 on 2020/10/5.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import SQLite3
import Foundation

class SQLiteDAO {
    
    static func connectDB() {
        // 搜尋資料庫路徑
        let target = "\(NSHomeDirectory())/Documents/ExampleDB.db"
        if !FileManager.default.fileExists(atPath: target) {
            let source = Bundle.main.path(forResource: "ExampleDB", ofType: ".db")!
            try? FileManager.default.copyItem(atPath: source, toPath: target)
        }
        // 開啟資料庫連線
        var db: OpaquePointer? = nil
        if sqlite3_open(target, &db) == SQLITE_OK {
            print("成功連線")
        } else {
            print("連線失敗")
        }
    }
    
}

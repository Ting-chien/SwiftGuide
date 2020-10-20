//
//  EmployeeDAO.swift
//  SwiftGuide
//
//  Created by 王庭謙 on 2020/10/8.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import Foundation

enum EmployeeTable: String, DBbaseEnum {
    
    case id = "id"
    case name = "name"
    case age = "age"
    case gender = "gender"
    case position = "position"
    
    static var tableName: String { "Employee" }
    
    var index: Int {
        return EmployeeTable.allCases.firstIndex(of: self)!
    }
}

class EmployeeDAO: SQLiteDAO<EmployeeTable> {
    
    var table: [String:String] =
    [
        "id" : "",
        "name" : "",
        "age" : "",
        "gender" : "",
        "position" : ""
    ]
    
    func insert(_ entity: EmployeeModel) {}
    
    func delete(_ id: String, _ name: String) {}
    
    func update(_ id: String, _ name: String, _ entity: EmployeeModel) {}
    
    func fetch(_ id: String, _ name: String) {}
}

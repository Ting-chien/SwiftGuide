//
//  RegexValidator.swift
//  TestingProject
//
//  Created by 王庭謙 on 2020/9/28.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit
import Foundation

enum DefaultRegex: String {
    /// 僅"英文字母"及"數字"
    case Alphanumeric = "^[a-zA-Z0-9]*$"
    /// 僅"數字"
    case Number = "^[0-9]*$"
    /// 僅"英文字母"、"數字"及@ - _ . 四個符號
    case Email = "^[a-zA-Z0-9\\@\\_\\-\\.]*$"
    /// 中文
    case zhPattern = "^[\\u4E00-\\u9FA5]*$"
    /// 英文
    case enPattern = "^[a-zA-Z]*$"
}

class RegexValidator {
    
    var pattern: String
    
    init(pattern: String) {
        self.pattern = pattern
    }
    
    // Default validation function
    func validate(input string: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern)
        if let matches = regex?.matches(in: string, range: NSMakeRange(0, (string as NSString).length)) {
            return matches.count > 0
        } else {
            return false
        }
    }
    
    // MARK: - Specific validataion functions
    
}

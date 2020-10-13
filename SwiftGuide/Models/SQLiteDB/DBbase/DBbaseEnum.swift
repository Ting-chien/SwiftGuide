//
//  DBbaseEnum.swift
//  SwiftGuide
//
//  Created by 王庭謙 on 2020/10/8.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import Foundation

protocol DBbaseEnum: CaseIterable, RawRepresentable {
    static var tableName: String { get }
}

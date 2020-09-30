//
//  TextFieldManager.swift
//  TestingProject
//
//  Created by 王庭謙 on 2020/9/25.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit
import Foundation

class TextFieldManager: NSObject, BaseTextFieldDelegate {
    
    var textFields = [CustomTextField]()

    convenience init(textFields: [CustomTextField]) {
        self.init()
        self.textFields = textFields
        self.textFields.forEach( {$0.field.manager = self})
    }
    
    func moveToNextField(_ textField: UITextField) {
        print("Move to next..")
        let nextTag = textField.tag + 1
        if let nextResponder = textFields.filter({ ($0.field.tag == nextTag) }).first {
            nextResponder.field.becomeFirstResponder()
        }
    }
    
    func moveToPrevField(_ textField: UITextField) {
        print("Move to prev..")
        let prevTag = textField.tag - 1
        if let prevResponder = textFields.filter({ ($0.field.tag == prevTag) }).first {
            prevResponder.field.becomeFirstResponder()
        }
    }

}

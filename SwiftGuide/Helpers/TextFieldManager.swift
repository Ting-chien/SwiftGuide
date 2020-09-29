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
    
    var textFields = [BaseTextField]()

    convenience init(textFields: [BaseTextField]) {
        self.init()
        self.textFields = textFields
        self.textFields.forEach( {$0.manager = self})
    }
    
    func moveToNextField(_ textField: UITextField) {
        print("Move to next..")
        let nextTag = textField.tag + 1
        if let nextTextField = textFields.filter({ ($0.tag == nextTag) }).first {
            nextTextField.becomeFirstResponder()
        }
    }
    
    func moveToPrevField(_ textField: UITextField) {
        print("Move to prev..")
        let prevTag = textField.tag - 1
        if let prevTextField = textFields.filter({ ($0.tag == prevTag) }).first {
            prevTextField.becomeFirstResponder()
        }
    }

}

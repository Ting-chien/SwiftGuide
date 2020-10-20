//
//  CustomTextFieldViewController.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/9/28.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

class CustomTextFieldViewController: UIViewController {

    var customTextFields: TextFieldManager?
    
    // Custom UITextField
    @IBOutlet weak var customField1: CustomTextField!
    @IBOutlet weak var customField2: CustomTextField!
    @IBOutlet weak var customField3: CustomTextField!
    @IBOutlet weak var customField4: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCustomTextField()
    }
    
    func setUpCustomTextField() {
        
        customField1.field.tag = 0
        customField1.field.textLengthLimit = 3
        customField1.field.regularExpression = .Alphanumeric
        customField1.field.placeholder = "Placeholder"
        
        customField2.field.tag = 1
        customField2.field.textLengthLimit = 5
        customField2.field.regularExpression = .Email
        customField2.field.textAlignment = .center
        customField2.field.text = "TEST"
        
        customField3.field.tag = 2
        customField3.field.textLengthLimit = 1
        customField3.field.regularExpression = .Number
        customField3.field.keyboardType = .numberPad
        
        customField4.field.tag = 3
        customField4.field.textLengthLimit = 3
        customField4.field.isSecure = true
        
        customTextFields = TextFieldManager(textFields: [customField1, customField2, customField3, customField4])
    }

}

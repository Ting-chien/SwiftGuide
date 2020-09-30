//
//  CustomTextFieldViewController.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/9/28.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

class CustomTextFieldViewController: UIViewController {

    var baseTextFields: TextFieldManager?
    var customTextFields: TextFieldManager?
    
    // Base UITextFields
    @IBOutlet weak var cardField1: BaseTextField!
    @IBOutlet weak var cardField2: BaseTextField!
    @IBOutlet weak var cardField3: BaseTextField!
    @IBOutlet weak var cardField4: BaseTextField!
    
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
    
//    目前設定以CustomTextField裡面再包一層BaseTextField為準，因此暫不起用該方法
//    func setUpBaseTextFields() {
//
//        // TextField1
//        cardField1.textLengthLimit = 3
//        cardField1.regularExpression = .Alphanumeric
//        cardField1.placeholder = "Placeholder"
//
//        // TextField2
//        cardField2.textLengthLimit = 5
//        cardField2.regularExpression = .Email
//        cardField2.textAlignment = .center
//
//        // TextField3
//        cardField3.textLengthLimit = 1
//        cardField3.regularExpression = .Number
//        cardField3.keyboardType = .numberPad
//
//        // TextField4
//        cardField4.isSecure = true
//
//        baseTextFields = TextFieldManager(textFields: [cardField1, cardField2, cardField3, cardField4])
//    }
}

//
//  CustomTextFieldViewController.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/9/28.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

class CustomTextFieldViewController: UIViewController {

    var textFields: TextFieldManager?
    
    @IBOutlet weak var cardField1: BaseTextField!
    @IBOutlet weak var cardField2: BaseTextField!
    @IBOutlet weak var cardField3: BaseTextField!
    @IBOutlet weak var cardField4: BaseTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
    }
    
    func setUpTextFields() {
        
        // TextField1
        cardField1.textLengthLimit = 3
        cardField1.regularExpression = .Alphanumeric
        cardField1.placeholder = "Placeholder"
        
        // TextField2
        cardField2.textLengthLimit = 5
        cardField2.regularExpression = .Email
        cardField2.textAlignment = .center
        
        // TextField3
        cardField3.textLengthLimit = 1
        cardField3.regularExpression = .Number
        cardField3.keyboardType = .numberPad
        
        // TextField4
        cardField4.isSecureTextEntry = true
        
        textFields = TextFieldManager(textFields: [cardField1, cardField2, cardField3, cardField4])
    }
    
}

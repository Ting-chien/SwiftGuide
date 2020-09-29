//
//  BaseTextField.swift
//  TestingProject
//
//  Created by 王庭謙 on 2020/9/26.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

protocol BaseTextFieldDelegate {
    func moveToPrevField(_ textField: UITextField)
    func moveToNextField(_ textField: UITextField)
}

class BaseTextField: UITextField, UITextFieldDelegate {
    
    var manager: BaseTextFieldDelegate?
    
    var defaultText: String = ""
    
    var viewcontroller: UIViewController? {
        var responder: UIResponder? = self.next
        repeat {
            if let vc = responder as? UIViewController {
                return vc
            } else {
                responder = responder?.next
            }
        } while responder != nil
        return nil
    }
    
    /// 字數限制
    var textLengthLimit: Int?
    /// 正則限制
    var regularExpression: DefaultRegex?
    /// 隱碼限制
    var isSecure: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        self.delegate = self
    }
    
    // MARK: - UITextField Override
    
    override func deleteBackward() {
        super.deleteBackward()
        if self.text == "" {
            self.manager?.moveToPrevField(self)
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        TapGestureHelper.shared.shouldAddTapGestureInWindow(window: self.window!)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = isSecure ? defaultText : textField.text, let range = Range(range, in: text) {
            
            var newText = ""
            
            // 驗證正則式
            if let regex = regularExpression?.rawValue {
                let validator = RegexValidator(pattern: regex)
                if validator.validate(input: string) {
                    newText = text.replacingCharacters(in: range, with: string)
                } else {
                    return false
                }
            } else {
                newText = text.replacingCharacters(in: range, with: string)
            }
            
            // 驗證數字限制
            if let limit = textLengthLimit, newText.count >= limit {
                if newText.count == limit { self.text = newText }
                self.manager?.moveToNextField(self)
                return false
            }
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // Undone
        
    }

    // MARK: - Keyboard move up/down
    
    @objc func keyboardWillShow(noti: NSNotification) {
        
        let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        if let views = viewcontroller?.view.subviews {
            for view in views {
                if view.isKind(of: UIScrollView.self) {
                    let scrollview = view as! UIScrollView
                    let contentInsect = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height+5, right: 0)
                    scrollview.contentInset = contentInsect
                }
            }
        }
    }
    
    @objc func keyboardWillHide(noti: NSNotification) {
        if let views = viewcontroller?.view.subviews {
            for view in views {
                if view.isKind(of: UIScrollView.self) {
                    let scrollview = view as! UIScrollView
                    let contentInsect: UIEdgeInsets = .zero
                    scrollview.contentInset = contentInsect
                }
            }
        }
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}
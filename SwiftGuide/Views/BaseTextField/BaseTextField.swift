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
    
    var hiddenText: String = ""
    
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
        if let text = isSecure ? hiddenText : textField.text, let range = Range(range, in: text) {
            
            var newText = ""
            
            // 正則表達式
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
            
            // 數字限制
            if let limit = textLengthLimit, newText.count >= limit {
                if newText.count == limit { self.text = newText }
                self.manager?.moveToNextField(self)
                return false
            }
            
            // 隱碼設定
            if isSecure {
                hiddenText = newText
            }
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if isSecure, let text = textField.text {
            textField.text = String(text.map{ ($0 == "*" ? $0 : "*")})
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        
        if let view = viewcontroller?.view {
            let frame = self.convert(self.bounds.origin, to: view)
            let visibleHeight = view.frame.size.height - keyboardSize.height
            let visiblePointY = frame.y + self.frame.size.height
            if visiblePointY >= visibleHeight {
                
                view.frame.origin.y = -(visiblePointY - visibleHeight)
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
        
        if let view = viewcontroller?.view {
            view.frame.origin.y = 0
        }
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

//
//  CustomTextField.swift
//  SwiftGuide
//
//  Created by 王庭謙 on 2020/9/29.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

class CustomTextField: UIView {
    
    @IBOutlet weak var field: BaseTextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle.init(for: self.classForCoder)
        let nib = UINib.init(nibName: "CustomTextField", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }

}

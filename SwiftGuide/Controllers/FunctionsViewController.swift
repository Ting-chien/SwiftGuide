//
//  FunctionsViewController.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/10/27.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

class FunctionsViewController: UIViewController {

    @IBOutlet weak var alertButton: UIButton! {
        didSet {
            alertButton.backgroundColor = .blue
            alertButton.setTitle("Alert Button", for: .normal)
            alertButton.setTitleColor(.white, for: .normal)
            alertButton.layer.cornerRadius = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func alertHandler(_ sender: Any) {
        let alertView = AlertViewController()
        alertView.show()
    }
    
    
}

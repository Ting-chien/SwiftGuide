//
//  FunctionsViewController.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/10/27.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

class FunctionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func alertHandler(_ sender: Any) {
        let alertView = AlertViewController()
        alertView.show()
    }
    
    
}

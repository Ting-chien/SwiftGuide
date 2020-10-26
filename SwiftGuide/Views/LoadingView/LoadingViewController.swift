//
//  LoadingViewController.swift
//  SwiftGuide
//
//  Created by eric on 2020/10/26.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spinner.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        spinner.startAnimating()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

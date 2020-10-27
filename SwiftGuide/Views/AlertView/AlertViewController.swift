//
//  AlertViewController.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/10/27.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    private var window: UIWindow!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(remove))
        contentView.addGestureRecognizer(tap)
    }
    
    func show() {
        let windowScene = UIApplication.shared
                        .connectedScenes
                        .filter { $0.activationState == .foregroundActive }
                        .first
        if let windowScene = windowScene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            self.window.windowLevel = .alert + 1
            self.window.rootViewController = UIViewController()
            self.window.backgroundColor = .clear
            self.window.makeKeyAndVisible()
            if #available(iOS 13, *) {
                self.window.overrideUserInterfaceStyle = .light
            }
        }
        
        self.modalPresentationStyle = .fullScreen
        self.window.rootViewController?.present(self, animated: false, completion: nil)
    }
    
    @objc func remove() {
        self.dismiss(animated: false, completion: nil)
    }
    
}

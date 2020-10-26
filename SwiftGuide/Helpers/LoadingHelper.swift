//
//  LoadingHelper.swift
//  SwiftGuide
//
//  Created by eric on 2020/10/26.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

class LoadingHelper {
    
    static let shared: LoadingHelper = LoadingHelper()
    private var window: UIWindow?
    private var isLoading = false
    
    func showLoadingPage() {
        DispatchQueue.main.async {
            if !self.isLoading {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.windowLevel = .statusBar
                self.window?.rootViewController = UIViewController()
                self.window?.backgroundColor = nil
                self.window?.isHidden = false
                if #available(iOS 13, *) {
                    self.window?.overrideUserInterfaceStyle = .light
                }
                
                let loadingView = LoadingViewController()
                loadingView.modalPresentationStyle = .fullScreen
                self.window?.rootViewController?.present(loadingView, animated: false, completion: nil)
                self.isLoading = true
            }
        }
    }
    
    func removeLoadingPage() {
        DispatchQueue.main.async {
            if self.isLoading {
                self.window?.isHidden = true
                self.window?.rootViewController?.dismiss(animated: false, completion: nil)
                self.window = nil
                self.isLoading = false
            }
        }
    }
    
}

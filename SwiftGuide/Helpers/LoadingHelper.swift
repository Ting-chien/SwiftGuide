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
    private var window: UIWindow!
    private var isLoading = false
    
    func showLoadingPage() {
        DispatchQueue.main.async {
            if !self.isLoading {
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
                
                let loadingView = LoadingViewController()
                loadingView.modalPresentationStyle = .fullScreen
                self.window.rootViewController?.present(loadingView, animated: false, completion: nil)
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

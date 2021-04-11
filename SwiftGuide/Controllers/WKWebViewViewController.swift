//
//  WKWebViewViewController.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2021/4/11.
//  Copyright © 2021 Ting-chien Wang. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewViewController: UIViewController, WKNavigationDelegate {
    
    var webView = WKWebView()
    var backwardBtn = UIBarButtonItem()
    var forwardBtn = UIBarButtonItem()
    
    let url = URL(string: "https://www.apple.com")!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        let request = URLRequest(url: url)
        webView.load(request)
        self.view.addSubview(webView)
        
        setNavigationButtons()
    }
    
    // loading...
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        LoadingHelper.shared.removeLoadingPage()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        LoadingHelper.shared.showLoadingPage()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        LoadingHelper.shared.removeLoadingPage()
    }
    
    // buttons setup
    func setNavigationButtons() {
        backwardBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(goBackward))
        forwardBtn = UIBarButtonItem(title: "前進", style: .plain, target: self, action: #selector(goForward))
        self.navigationItem.leftBarButtonItem = backwardBtn
        self.navigationItem.rightBarButtonItem = forwardBtn
    }
    
    @objc func goForward() {
        if self.webView.canGoForward {
            self.webView.goForward()
        }
    }
    
    @objc func goBackward() {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

}

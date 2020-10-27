//
//  ImageDownloaderViewController.swift
//  SwiftGuide
//
//  Created by eric on 2020/10/26.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

class ImageDownloaderViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchImage()
    }
    
    func fetchImage() {
        let url = URL(string: "https://i.imgur.com/e7T3Vjt.jpg")
        
        if let url = url {
            LoadingHelper.shared.showLoadingPage()
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    print("Did download image data.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(5)) {
                        self.image.image = UIImage(data: data)
                        LoadingHelper.shared.removeLoadingPage()
                    }
                }
            }.resume()
        }
    }
    
    // MARK: Grand Centrail Dispatch Examples
    
    func syncQueue() {
        let queue = DispatchQueue(label: "com.appcoda.queue")
        
        queue.sync {
            for i in 0..<100 {
                print("🔴", i)
            }
        }

        for i in 100..<200 {
            print("🤗", i)
        }
        
    }
    
    func asyncQueue() {
        
        let queue1 = DispatchQueue(label: "com.appcoda.queue1", qos: .background)
        let queue2 = DispatchQueue(label: "com.appcoda.queue2", qos: .userInitiated)

        queue1.async {
            for i in 0..<100 {
                print("🔴", i)
            }
        }

        queue2.async {
            for i in 100..<200 {
                print("🔵", i)
            }
        }
        
    }
    
    func concurrentQueues() {
        let queue = DispatchQueue(label: "com.appcoda.queue", qos: .utility, attributes: .concurrent)
        
        queue.async {
            for i in 0..<100 {
                print("🔴", i)
            }
        }
        
        queue.async {
            for i in 100..<200 {
                print("🔵", i)
            }
        }
        
        queue.async {
            for i in 1000..<1100 {
                print("🤗", i)
            }
        }
        
    }
    
    func queueWithDelay() {
        
        let additionalTime: DispatchTimeInterval = .seconds(3)
        let delayQueue = DispatchQueue(label: "com.appcoda.delayqueue", qos: .userInitiated)
        
        print(Date())
        delayQueue.asyncAfter(deadline: .now() + additionalTime) {
            print(Date())
        }
    }

}

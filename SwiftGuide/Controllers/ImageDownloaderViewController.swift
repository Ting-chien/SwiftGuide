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

}

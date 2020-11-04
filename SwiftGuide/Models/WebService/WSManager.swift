//
//  WSManager.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/11/4.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import Foundation

class WSManager: NSObject {
    
    func requestWithUrl(urlString: String, parameters: [String:Any], completion: @escaping (Data)->(Void)) {
        
        var urlComponent = URLComponents(string: urlString)
        urlComponent?.queryItems = []
        
        for (key, value) in parameters {
            guard let value = value as? String else { return }
            urlComponent?.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        if let url = urlComponent?.url {
            let request = URLRequest(url: url)
            fetchDataByDataTask(request: request, completion: completion)
        }
    }
    
    func fetchDataByDataTask(request: URLRequest, completion: @escaping (Data)->(Void)) {
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                completion(data)
            }
        }.resume()
        
    }
}

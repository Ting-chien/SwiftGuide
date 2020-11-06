//
//  HttpRequestExample.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/11/6.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import Foundation

class HttpRequestExample {
    
    // MARK: - Http request types
    
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
    
    func requestWithHeader(urlString: String, parameters: [String:String], completion: @escaping (Data)->(Void)) {
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        for (key, value) in parameters {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        fetchDataByDataTask(request: request, completion: completion)
    }
    
    func requestWithJSONBody(urlString: String, parameters: [String:Any], completion: @escaping (Data)->(Void)) {
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        fetchDataByDataTask(request: request, completion: completion)
    }
    
    func requestWithUrlencoded(urlString: String, parameters: String, completion: @escaping (Data)->(Void)) {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        fetchDataByDataTask(request: request, completion: completion)
    }
    
    func requestWithFormData(urlString: String, parameters: [String: Any], dataPath: [String: Data], completion: @escaping (Data) -> Void) {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary+\(arc4random())\(arc4random())"
        var body = Data()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        for (key, value) in dataPath {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(arc4random())\"\r\n") //此處放入file name，以隨機數代替，可自行放入
            body.appendString(string: "Content-Type: image/png\r\n\r\n") //image/png 可改為其他檔案類型 ex:jpeg
            body.append(value)
            body.appendString(string: "\r\n")
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        request.httpBody = body
        fetchDataByDataTask(request: request, completion: completion)
    }
    
    // MARK: - URLSession work
    
    func fetchDataByDataTask(request: URLRequest, completion: @escaping (Data)->(Void)) {
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                completion(data)
            }
        }.resume()
        
    }
    
}

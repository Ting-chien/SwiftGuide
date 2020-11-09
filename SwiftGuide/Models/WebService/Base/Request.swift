//
//  Request.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/11/6.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case GET
    case POST
    
    var adapter: AnyAdapter {
        return AnyAdapter { (req) -> URLRequest in
            var req = req
            req.httpMethod = self.rawValue
            return req
        }
    }
}

enum ContentType: String {
    case urlForm = "application/x-www-form-urlencoded; charset=utf-8"
    case json = "application/json"
    
    var headerAdapter: AnyAdapter {
        return AnyAdapter { (req) -> URLRequest in
            var req = req
            req.setValue(self.rawValue, forHTTPHeaderField: "Content-Type")
            return req
        } // 這裡是一個閉包化的初始函數
    }
    
    func dataAdapter(data: [String:Any]) -> RequestAdapter {
        switch self {
        case .json:
            return JsonRequestDataAdapter(data: data)
        case .urlForm:
            return UrlRequestDataAdapter(data: data)
        }
    }
}

// MARK: - Request protocol-based

protocol Request {
    
    associatedtype Response: Decodable
    
    var url: URL { get }
    var method: HttpMethod { get }
    var parameters: [String:Any] { get }
    var contentType: ContentType { get }
    
    var adapters: [RequestAdapter] { get }
    var decisions: [Decision] { get }
    
}

extension Request {
    
    var adapters: [RequestAdapter] {
        return [
            // 帶入各種adapters，像是請求方法、串接contentType
            method.adapter,
            RequestContentAdapter(method: method, contentType: contentType, contents: parameters)
        ]
    }
    
    var decisions: [Decision] {
        return [
            // 進行各種結果處理，像是更新token, 解析json等等
            RefreshTokenDecision(),
            RetryDecision(leftCount: 2),
            BadResponseStatusCodeDecision(),
            DataMappingDecision(condition: { $0.isEmpty }, transform: { (_) -> Data in
                return "{}".data(using: .utf8)!
            }),
            ParseJsonDataDecision()
        ]
    }
    
    func buildRequest() throws -> URLRequest {
        let request = URLRequest(url: url)
        return try adapters.reduce(request, { try $1.adapted($0) })
    }
}

// MARK: - Basic request

struct RefreshTokenRequest: Request {
    
    struct Response: Decodable {
        let token: String
    }
    
    var url = URL(string: "some/url")!
    var method: HttpMethod = .POST
    var contentType: ContentType = .json
    
    var parameters: [String : Any] {
        return ["refreshToken": refreshToken]
    }
    
    let refreshToken: String
    
}

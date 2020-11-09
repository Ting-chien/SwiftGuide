//
//  Adapters.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/11/6.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import Foundation

protocol RequestAdapter {
    func adapted(_ request: URLRequest) throws -> URLRequest
}

struct AnyAdapter: RequestAdapter {
    let block: (URLRequest) throws -> URLRequest
    func adapted(_ request: URLRequest) throws -> URLRequest {
        return try block(request)
    }
}

struct RequestContentAdapter: RequestAdapter {
    
    let method: HttpMethod
    let contentType: ContentType
    let contents: [String:Any]
    
    /*
     根據HttpMethods或contentType來撰寫內部方法，
     若可確認專案中的API使用都是依據特定method或contentType，
     則單獨處理該方法即可。
     */
    func adapted(_ request: URLRequest) throws -> URLRequest {
        switch method {
        case .GET:
            return try UrlQueryDataAdapter(data: contents).adapted(request)
        case .POST:
            let headerAdapter = contentType.headerAdapter
            let dataAdapter = contentType.dataAdapter(data: contents)
            let req = try headerAdapter.adapted(request)
            return try dataAdapter.adapted(req)
        }
    }
}

struct UrlQueryDataAdapter: RequestAdapter {
    let data: [String:Any]
    func adapted(_ request: URLRequest) throws -> URLRequest {
        // 實作GET的請求方式
    }
}

struct JsonRequestDataAdapter: RequestAdapter {
    let data: [String:Any]
    func adapted(_ request: URLRequest) throws -> URLRequest {
        // 實作POST的請求方式，並透過JSON body的格式
    }
}

struct UrlRequestDataAdapter: RequestAdapter {
    let data: [String:Any]
    func adapted(_ request: URLRequest) throws -> URLRequest {
        // 實作GET的請求方式，並透過URL encoded的格式
    }
}


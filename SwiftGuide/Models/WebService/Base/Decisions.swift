//
//  Decisions.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/11/6.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import Foundation

protocol Decision {
    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool
    func apply<Req: Request>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        done closure: @escaping (DecisionAction<Req>) -> Void)
}

enum DecisionAction<Req: Request> {
    case continueWith(Data, HTTPURLResponse)
    case restartWith([Decision])
    case errored(Error)
    case done(Req.Response)
}

// MARK: - Decision making methods

/*
 提供回傳的data預先處理的方式，
 若是空值<empty>，則轉成{}。
 裡面可定義#if_server_is_not_working來注入測試資料
 */
struct DataMappingDecision: Decision {
    
    let condition: (Data) -> Bool
    let transform: (Data) -> Data
    
    init(condition: @escaping (Data) -> Bool, transform: @escaping (Data) -> Data) {
        self.condition = condition
        self.transform = transform
    }
    
    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool {
        return condition(data)
    }
    
    func apply<Req: Request>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        done closure: @escaping (DecisionAction<Req>) -> Void)
    {
        closure(.continueWith(transform(data), response))
    }
}

/*
 當HTTPRequest.response.statusCode == "403"時，
 向API_server請求更新token，
 若還是失敗，則當成錯誤處理。
 */
struct RefreshTokenDecision: Decision {
    
    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool {
        return response.statusCode == 403
    }
    
    func apply<Req: Request>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        done closure: @escaping (DecisionAction<Req>) -> Void)
    {
        let client = HTTPClient(session: .shared)
        let refreshTokenRequest = RefreshTokenRequest(refreshToken: "abc123")
        
        // TODO: 發出refresh token的請求
    }
}

/*
 解析回傳的JSON資料，在souldApply func中，
 不管回傳資料為何，一律返回true來進行解析
 */
struct ParseJsonDataDecision: Decision {
    
    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool {
        return true
    }
    
    func apply<Req: Request>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        done closure: @escaping (DecisionAction<Req>) -> Void)
    {
        do {
            let decoder = JSONDecoder()
            let value = try decoder.decode(Req.Response.self, from: data)
            closure(.done(value))
        } catch {
            closure(.errored(error))
        }
    }
}

struct RetryDecision: Decision {
    
    let leftCount: Int
    
    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool {
        let isStatusCodeValid = (200..<300).contains(response.statusCode)
        return !isStatusCodeValid && leftCount > 0
    }

    func apply<Req: Request>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        done closure: @escaping (DecisionAction<Req>) -> Void)
    {
        // TODO: 處理新的Decision設定
    }
}

struct BadResponseStatusCodeDecision: Decision {
    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool {
        return !(200..<300).contains(response.statusCode)
    }

    func apply<Req: Request>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        done closure: @escaping (DecisionAction<Req>) -> Void)
    {
        // TODO: 處理錯誤訊息的回覆
    }
}


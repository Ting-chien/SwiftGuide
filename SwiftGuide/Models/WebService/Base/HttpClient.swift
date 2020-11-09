//
//  HttpClient.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/11/6.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import Foundation

enum ResponseError: Error {
    case nilData
    case nonHttpResponse
    case tokenError
    case apiError(error: APIError, statusCode: Int)
}

struct APIError: Decodable {
    let code: Int
    let reason: String
}

struct HTTPClient {
    
    let session: URLSession
    
    func send<Req: Request>(
        _ request: Req,
        decisions: [Decision]? = nil,
        handler: @escaping (Result<Req.Response, Error>) -> Void)
    {
        let urlRequest: URLRequest
        do {
            urlRequest = try request.buildRequest()
        } catch {
            handler(.failure(error))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data else {
                handler(.failure(error ?? ResponseError.nilData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                handler(.failure(ResponseError.nonHttpResponse))
                return
            }
            
            self.handleDecisions(request,
                                 data: data,
                                 response: response,
                                 decisions: decisions ?? request.decisions,
                                 handler: handler)
        }
        task.resume()
    }
    
    func handleDecisions<Req: Request>(
        _ request: Req,
        data: Data,
        response: HTTPURLResponse,
        decisions: [Decision],
        handler: @escaping (Result<Req.Response, Error>) -> Void)
    {
        guard !decisions.isEmpty else {
            fatalError("No decisions left to be handled.")
        }
        
        // 取出第一個需執行的策略
        var decisions = decisions
        let current = decisions.removeFirst()
        
        // 判斷該被取出的策略是否該被執行，若否則往下一個策略迭代
        guard current.shouldApply(request: request, data: data, response: response) else {
            handleDecisions(request, data: data, response: response, decisions: decisions, handler: handler)
            return
        }
        
        // 執行策略
        current.apply(request: request, data: data, response: response) { (action) in
            switch action {
            case .continueWith(let data, let response):
                self.handleDecisions(request, data: data, response: response, decisions: decisions, handler: handler)
            case .restartWith(let decisions):
                self.send(request, decisions: decisions, handler: handler)
            case .errored(let error):
                handler(.failure(error))
            case .done(let value):
                handler(.success(value))
            }
        }
        
    }
}


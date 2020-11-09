//
//  HttpNaiveBase.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/11/9.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import UIKit

let decoder = JSONDecoder()

struct HttpNaiveRequest {

    let url: URL
    let method: String
    let parameters: [String: Any]
    let headers: [String: String]

    func buildRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method

        request.allHTTPHeaderFields = headers

        if method == "GET" {
            var components = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false)!
            components.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: $0.value as? String)
            }
            request.url = components.url
        } else {
            if headers["Content-Type"] == "application/json" {
                request.httpBody = try? JSONSerialization
                    .data(withJSONObject: parameters, options: [])
            } else if headers["Content-Type"] == "application/x-www-form-urlencoded" {
                request.httpBody = parameters
                    .map { "\($0.key)=\($0.value)" }
                    .joined(separator: "&")
                    .data(using: .utf8)
            } else {
                //...
            }
        }

        return request
    }
}

struct HttpNaiveResponse<T: Codable> {
    let value: T?
    let response: HTTPURLResponse?
    let error: Error?

    init(data: Data?, response: URLResponse?, error: Error?) throws {
        self.value = try data.map { try decoder.decode(T.self, from: $0) }
        self.response = response as? HTTPURLResponse
        self.error = error
    }
}

struct HttpSimpleClient {
    
    let session: URLSession = .shared
    
    func send<T: Codable>(
        _ request: HttpNaiveRequest,
        handler: @escaping (HttpNaiveResponse<T>?) -> Void)
    {
        let urlRequest = request.buildRequest()
        let task = session.dataTask(with: urlRequest) {
            data, response, error in
            handler(try? HttpNaiveResponse(
                data: data,
                response: response,
                error: error))
        }
        task.resume()
    }
    
    func send<T: Codable>(
        _ request: HttpNaiveRequest,
        handler: @escaping (Result<T, Error>) -> Void)
    {
        let urlRequest = request.buildRequest()

        let task = session.dataTask(with: urlRequest) {
            data, response, error in

            if let error = error {
                handler(.failure(error))
                return
            }

            guard let data = data else {
                handler(.failure(ResponseError.nilData))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                handler(.failure(ResponseError.nonHttpResponse))
                return
            }

            if response.statusCode >= 300 {
                do {
                    let error = try decoder.decode(APIError.self, from: data)
                    if response.statusCode == 403 && error.code == 999 {
                        // 憑證失效，須更新token
                    } else {
                        handler(.failure(
                            ResponseError.apiError(
                                error: error,
                                statusCode: response.statusCode)
                            )
                        )
                    }
                } catch {
                    handler(.failure(error))
                }
            }

            do {
                let realData = data.isEmpty ? "{}".data(using: .utf8)! : data
                let value = try decoder.decode(T.self, from: realData)
                handler(.success(value))
            } catch {
                handler(.failure(error))
            }
        }
        task.resume()
    }

}

// MARK: - How naive HTTP functions work (demo)

struct HttpBinPostResult: Codable {
    struct Form: Codable { let foo: String }
    let form: Form
}

/*
let client = HttpSimpleClient()
let request = HttpNaiveRequest(
    url: URL(string: "https://httpbin.org/post")!,
    method: "POST", parameters: ["foo": "bar"],
    headers: ["Content-Type": "application/x-www-form-urlencoded"]
)

client.send(request) { (res: HttpNaiveResponse<HttpBinPostResult>?) in
    print(res?.value?.form.foo ?? "<nil>")
}

client.send(request) { (res: Result<HttpBinPostResult, Error>) in
    switch res {
    case .success(let value): print(value.form.foo)
    case .failure(let error): print(error)
    }
}
 */

//
//  WS_BinPostModel.swift
//  SwiftGuide
//
//  Created by TING-CHIEN WANG on 2020/11/6.
//  Copyright © 2020 Ting-chien Wang. All rights reserved.
//

import Foundation

struct WS_BinPostRequestModel: Request {
    
    typealias Response = WS_BinPostResponseModel
    
    let foo: String
    
    let url = URL(string: "https://httpbin.org/post")!
    let method = HttpMethod.POST
    let contentType = ContentType.urlForm
    var parameters: [String : Any] {
        return ["foo": foo]
    }
    
}

struct WS_BinPostResponseModel: Codable {
    struct Form: Codable { let foo: String }
    let form: Form
}

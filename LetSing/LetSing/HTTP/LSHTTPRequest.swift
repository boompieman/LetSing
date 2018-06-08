//
//  LSHTTPREquest.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation

enum LSHTTPMethod: String {

    case post = "POST"

    case get = "GET"

    case patch = "PATCH"

    case delete = "DELETE"
}

protocol LSHTTPRequest {
    //If there are no custom header, adaptor doesn't need to implemete this method.
//    func customHeader() -> [String: String]

    func urlParameter() -> String

    func httpMethod() -> LSHTTPMethod

    func requestParameters() -> [String: String]

    func urlString() -> String

    func request() throws -> URLRequest
}

extension LSHTTPRequest {

    func request() throws -> URLRequest {

        var url = URLComponents(string: urlString() + urlParameter())

        let parameters = requestParameters()

        url?.queryItems = [URLQueryItem]()

        for (key, value) in parameters {
            url?.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        guard let requestUrl = url else {

            throw LSError.youtubeError
        }

        var request = URLRequest(url: requestUrl.url!)

//        request.allHTTPHeaderFields = requestHeader()

        request.httpMethod = httpMethod().rawValue

//        request.httpBody = try JSONSerialization.data(

//            withJSONObject: requestBody(),
//            options: .prettyPrinted
//
//        )

        return request
    }
}

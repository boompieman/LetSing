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

enum LSHTTPHeader: String {

    case authorization = "Authorization"

    case contentType = "Content-Type"
}

enum LSHTTPContentType: String {

    case json = "application/json"
}

protocol LSHTTPRequest {
    //If there are no custom header, adaptor doesn't need to implemete this method.
//    func customHeader() -> [String: String]

    func urlParameter() -> String

    func httpMethod() -> LSHTTPMethod

    //Optional

//    func requestHeader() -> [String: String]

    func requestParameters() -> [String: String]

    func urlString() -> String

    func requestFromYoutube() throws -> URLRequest
}

extension LSHTTPRequest {

//    func customHeader() -> [String: String] { return [:] }
//
//    func requestHeader() -> [String: String] {
//
//        var header = customHeader()
//
//        switch self.httpMethod() {
//
//        case .post, .patch:
//
//            header[LKHTTPHeader.contentType.rawValue] = LKHTTPContentType.json.rawValue
//
//        default:
//
//            break
//        }
//
//        guard let authorization = UserManager.shared.getUserToken() else {
//
//            return header
//        }
//
//        header[LKHTTPHeader.authorization.rawValue] = authorization
//
//        return header
//    }

//    func requestBody() -> [String: Any] { return [:] }

    func urlString() -> String { return LSConstants.youtubeUrl + urlParameter() }

    func requestFromYoutube() throws -> URLRequest {

        var url = URLComponents(string: urlString())

        let parameters = requestParameters()

        url?.queryItems = [URLQueryItem]()

        for (key, value) in parameters {
            url?.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        guard let youtubeUrl = url else {

            throw LSError.youtubeError
        }

        var request = URLRequest(url: youtubeUrl.url!)

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

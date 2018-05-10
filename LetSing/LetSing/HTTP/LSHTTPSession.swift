//
//  LSHTTPSession.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import Alamofire

class LSHTTPClient {

    static let shared = LSHTTPClient()

    private let queue: DispatchQueue

    private init () {

        queue = DispatchQueue(label: String(describing: LSHTTPClient.self) + UUID().uuidString, qos: .default, attributes: .concurrent)
    }

    @discardableResult
    private func request(
        _ request: URLRequestConvertible,
        success: @escaping (Data) -> Void,
        failure: @escaping (Error) -> Void
        ) -> DataRequest {

        return Alamofire.SessionManager.default.request(request).validate().responseData(
            queue: queue,
            completionHandler: { response in

                switch response.result {

                case .success(let data):

                    success(data)

                case .failure(let error):

                    failure(error)

                }
        }
        )
    }

    @discardableResult
    func request(
        _ LSHTTPRequest: LSHTTPRequest,
        success: @escaping (Data) -> Void,
        failure: @escaping (Error) -> Void
        ) -> DataRequest? {

        do {

            return try request(LSHTTPRequest.requestFromYoutube(), success: success, failure: failure)

        } catch {

            failure(error)

            return nil
        }
    }

}


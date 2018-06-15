//
//  LSHTTPSession.swift
//  LetSing
//
//  Created by MACBOOK on 2018/5/4.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import Foundation
import Alamofire

typealias DataCallBack = (Data) -> Void
typealias ErrorCallBack = (Error) -> Void

protocol LSHTTPApiClient {
    @discardableResult
    func requestAlamofire(
        _ request: URLRequestConvertible,
        success: @escaping DataCallBack,
        failure: @escaping ErrorCallBack
        ) -> DataRequest?
}

struct ApiClient: LSHTTPApiClient {

    let queue: DispatchQueue

    @discardableResult
    func requestAlamofire(
        _ request: URLRequestConvertible,
        success: @escaping (Data) -> Void,
        failure: @escaping (Error) -> Void
        ) -> DataRequest? {
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

}

class LSHTTPClient {

    static let shared = LSHTTPClient()

    let queue: DispatchQueue

    var apiClient: LSHTTPApiClient

    private init () {

        queue = DispatchQueue(label: String(describing: LSHTTPClient.self) + UUID().uuidString, qos: .default, attributes: .concurrent)

        apiClient = ApiClient(queue: queue)
    }

    // 當你 return 的東西沒有進入一個值，為避免compiler給予警告，所以會加discardable
    // ex: _ = LSHTTPClient.shared.request
    @discardableResult
    func request(
        _ LSHTTPRequest: LSHTTPRequest,
        success: @escaping (Data) -> Void,
        failure: @escaping (Error) -> Void
        ) -> DataRequest? {

        do {

            return try apiClient.requestAlamofire(LSHTTPRequest.request(), success: success, failure: failure)

        } catch {

            failure(error)
            return nil
        }
    }
}

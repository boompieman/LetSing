//
//  LSHTTPClientTests.swift
//  LetSingTests
//
//  Created by MACBOOK on 2018/6/15.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import XCTest
@testable import LetSing
import Alamofire
//
enum StubRequest: LSHTTPRequest {

    case getMockData

    func urlString() -> String {
        return ""
    }

    func urlParameter() -> String {
        return ""
    }

    func httpMethod() -> LSHTTPMethod {
        return .get
    }

    func requestParameters() -> [String : String] {
        return [
            "":""
        ]
    }
}

//class FakeDataRequest: DataRequest {
//
//    init() {
//        super.init(rawValue: 1)
//    }
//}

class MockHttpClient: LSHTTPApiClient {

    let queue: DispatchQueue

    var flag: Bool = false

    var getRequest: URLRequestConvertible?

    init(queue: DispatchQueue) {
        self.queue = queue
    }

    @discardableResult
    func requestAlamofire(_ request: URLRequestConvertible, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) -> DataRequest? {

        self.flag = true

        self.getRequest = request

        return nil

    }
}

class LSHTTPClientTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_request_IsClinetWork() {

        let httpClient = LSHTTPClient.shared

        let mockHttpClient = MockHttpClient(queue: httpClient.queue)

        httpClient.apiClient = mockHttpClient

        let inputRequest = StubRequest.getMockData

        httpClient.request(inputRequest, success: { (data) in }) { (error) in }

        guard let outputRequest = mockHttpClient.getRequest as? StubRequest else { return }

        XCTAssertEqual(inputRequest, outputRequest)
        XCTAssertTrue(mockHttpClient.flag)
    }
}

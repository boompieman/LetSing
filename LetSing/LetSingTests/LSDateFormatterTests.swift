//
//  LSDateFormatterTests.swift
//  LetSingTests
//
//  Created by MACBOOK on 2018/6/14.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

//TDD
//由紅，轉綠，再重構

import XCTest

@testable import LetSing

struct MockFormat: LSDateFormatterUsable {
    var format: String {
        return "yyyy-MM-dd HH:mm:ss"
    }
}

class LSDateFormatterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_GetCurrentTime_IsCorrectFormat() {

        let mockFormat = MockFormat()

        XCTAssertEqual(LSConstants.dateFormat, mockFormat.format)
    }

}

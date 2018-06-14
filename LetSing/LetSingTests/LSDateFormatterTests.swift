//
//  LetSingTests.swift
//  LetSingTests
//
//  Created by MACBOOK on 2018/6/13.
//  Copyright © 2018年 MACBOOK. All rights reserved.
//

import XCTest
@testable import LetSing

class LSDateFormatterTests: XCTestCase {

    var lsFormatter: LSDateFormatter!

    override func setUp() {
        super.setUp()

        lsFormatter = LSDateFormatter()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        lsFormatter = nil
        super.tearDown()
    }

    func test_Data_IsCurrentTime() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        // 1. given

//        let formatter = DateFormatter()
//        let date = Date()
//        let interval = date.timeIntervalSince1970

        let format = LSConstants.dateFormat

        lsFormatter = LSDateFormatter(format: format)

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = format

        let expectOutput = dateFormatter.string(from: Date())

        // 2. when
        let output = lsFormatter.getCurrentTime()

        // 3. then
        XCTAssertEqual(expectOutput, output)

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

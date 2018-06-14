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

class LSDateFormatterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_GetCurrentTime_IsCurrentTime() {

        let input = LSConstants.dateFormat

        let lsFormatter = LSDateFormatter(format: input)

        let output = lsFormatter.getCurrentTime()

        let date = Date()

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = input

        let expectOutput = dateFormatter.string(from: date)

        XCTAssertEqual(output, expectOutput)
    }

    func test_GetCurrentTime_IsCorrectFormat() {

        let input = "yyyy-MM-dd HH:mm:ss"

        let lsFormatter = LSDateFormatter(format: input)

        let output = lsFormatter.getCurrentTime()

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = input

        let expectOuput = dateFormatter.string(from: Date())

        XCTAssertEqual(output, expectOuput)
    }

}

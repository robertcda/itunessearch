//
//  StringExtensionsTest.swift
//  iTunesSearchTests
//
//  Created by robert on 01/08/18.
//  Copyright © 2018 robert. All rights reserved.
//

import XCTest
@testable import iTunesSearch

class StringExtensionsTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSpaceReplacement() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual("A B".replaceSpaceWithAPlus, "A+B")
        XCTAssertEqual("A B C".replaceSpaceWithAPlus, "A+B+C")
        XCTAssertEqual("A".replaceSpaceWithAPlus, "A")
    }
    func testNonEmptyString(){
        XCTAssertNil("".nonEmptyString)
        XCTAssertNotNil("A".nonEmptyString)
        XCTAssertNotNil("A12".nonEmptyString)
    }
}

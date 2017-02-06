//
//  hubchatTestappTests.swift
//  hubchatTestappTests
//
//  Created by Dmitry on 06.02.17.
//  Copyright © 2017 hubchat. All rights reserved.
//

import XCTest
@testable import hubchatTestapp

class hubchatTestappTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let dictionaryWithNested = ["key1": ["key2": "value1"]]
        XCTAssert(dictionaryWithNested.getValue(forKeyPath: ["key1", "key2"]) as? String == "value1", "Nested value cannot be retrieved")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

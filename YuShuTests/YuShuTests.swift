//
//  YuShuTests.swift
//  YuShuTests
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 coderX. All rights reserved.
//

import XCTest
@testable import YuShu

class YuShuTests: XCTestCase {
    
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
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            let fons = UIFont.familyNames
            for item in fons {
                print(item + "-----------------")
                let fonName = UIFont.fontNames(forFamilyName: item)
                for name in fonName{
                    print(name)
                }
            }
            // Put the code you want to measure the time of here.
        }
    }
    
}

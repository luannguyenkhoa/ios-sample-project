//
//  StringExtText.swift
//  ServiceKitTests
//
//  Copyright © 2019 Agility. All rights reserved.
//

import XCTest
@testable import ServiceKit

class StringExtText: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testTrim() {
    let testStr = "jfksdjf "
    XCTAssertEqual(testStr.trim(), "jfksdjf", "Should be trimmed")
    
    let testStr2 = "  fsdf ksdf              "
    XCTAssertEqual(testStr2.trim(), "fsdf ksdf")
    
    let testStr3 = "  fsdf ksdf   fdkkkf           "
    XCTAssertEqual(testStr3.trim(), "fsdf ksdf   fdkkkf")
  }
  
  func testTruncate() {
    let testStr = "oeropopopopooooo ooooo"
    XCTAssertEqual(testStr.truncate(length: 10), "oeropopopo")
    
    XCTAssertEqual(testStr.truncate(length: 100), "oeropopopopooooo ooooo")
    
    XCTAssertEqual(testStr.truncate(length: -1), "oeropopopopooooo ooooo")
  }
  
  func testIsZero() {
    XCTAssertTrue("0".isZero)
    XCTAssertTrue("0.0".isZero)
    XCTAssertTrue("0.0000000000000".isZero)

    XCTAssertFalse("a".isZero)
    XCTAssertFalse("1".isZero)
    XCTAssertFalse("0.1".isZero)
    XCTAssertFalse("0.0000000001".isZero)
  }
  
  func testSub() {
    let testStr = "kkkkkkkkkkkkkkk"
    XCTAssertEqual(testStr.substring(to: 5), "kkkkk")
    
    XCTAssertEqual(testStr.substring(from: 5), "kkkkkkkkkk")
    XCTAssertEqual(testStr[...5], "kkkkk")
    XCTAssertEqual(testStr[5...], "kkkkkkkkkk")
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}

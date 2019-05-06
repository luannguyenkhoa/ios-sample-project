//
//  ViewExtTest.swift
//  ServiceKitTests
//
//  Copyright © 2019 Agility. All rights reserved.
//

import XCTest
@testable import ServiceKit

class ViewExtTest: XCTestCase {
  
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
  
  func testSnapshot() {
    let mainView = UIView(frame: UIScreen.main.bounds)
    let snapshot = mainView.snapshot()
    XCTAssertNotNil(snapshot, "Snapshot should always be taken successfully")
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}

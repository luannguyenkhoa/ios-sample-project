import XCTest
@testable import SampleKit

class Utility: XCTestCase {
  
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
  
  func testFormatCounter() {
    let counters = [1, 10, 100, 1000, 10000, 100000]
    let expectedResults = ["1", "10", "100", "1K", "10K", "100K"]
    let results = counters.map { SampleKit.Utility.formatCounter($0) }
    XCTAssert(results.elementsEqual(expectedResults), "Should equal")
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}

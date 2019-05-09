//
//  SignInUITests.swift
//  iOSSampleUITests
//
//  Copyright © 2019 Agility. All rights reserved.
//

import XCTest
@testable import iOSSample
import ServiceKit

class SignInUITests: XCTestCase {
  
  var app: XCUIApplication!
  var query: XCUIElementQuery!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchEnvironment = ["isUITest": ""]
    query = app.otherElements
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    app.launch()
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func test_signinButton_enable() {
    
    XCTAssertTrue(query.buttons["Sign In"].exists)
    XCTAssertFalse(query.buttons["Sign In"].isEnabled)
    
    /// Enter values to enable button
    query.textFields["Email"].tap()
    query.textFields["Email"].typeText("abc@gmail.com")
    query.secureTextFields["Password"].tap()
    query.secureTextFields["Password"].typeText("abcd1234")
    
    XCTAssertTrue(query.buttons["Sign In"].isEnabled)
    
    let delete4LastChars = (0...3).map{_ in XCUIKeyboardKey.delete.rawValue }.joined()
    query.secureTextFields["Password"].typeText(delete4LastChars)
    XCTAssertFalse(query.buttons["Sign In"].isEnabled)
  }
  
  func test_present_error_popup() {
    query.textFields["Email"].tap()
    query.textFields["Email"].typeText("abc@gmail.com")
    query.secureTextFields["Password"].tap()
    query.secureTextFields["Password"].typeText("abcd1234")
    
    /// Press Sign In with typed credentials
    query.buttons["Sign In"].tap()
    
    sleep(1)
    XCTAssertTrue(query.alerts.element.exists)
    XCTAssertEqual(query.alerts.element.title, "")
  }
}

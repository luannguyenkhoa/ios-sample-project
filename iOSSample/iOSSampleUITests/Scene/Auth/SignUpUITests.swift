//
//  SignUpUITests.swift
//  iOSSampleUITests
//
//  Copyright © 2019 Agility. All rights reserved.
//

import XCTest
@testable import iOSSample

class SignUpUITests: XCTestCase {
  
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
    
    /// Present SignUp view
    query.buttons["Sign Up"].tap()
    sleep(1)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func test_signupButton_disable() {
    
    /// If the app has multiple Sign Up button, we should find them all and then getting the last one
    /// it is the element of our current viewcontroller
    let btns = query.buttons.matching(identifier: "Sign Up")
    let btn = btns.element(boundBy: btns.count - 1)
    XCTAssertFalse(btn.isEnabled)
    
    /// Enter values to enable button
    let emailField = query.textFields.matching(identifier: "Email").element(boundBy: btns.count - 1)
    emailField.tap()
    emailField.typeText("abc@gmail.com")
    
    XCTAssertTrue(btn.isEnabled)
  }
}

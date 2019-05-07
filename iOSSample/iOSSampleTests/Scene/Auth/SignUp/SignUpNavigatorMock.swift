//
//  SignUpNavigatorMock.swift
//  iOSSampleTests
//
//  Copyright © 2019 Agility. All rights reserved.
//

@testable import iOSSample

class SignUpNavigatorMock: SignUpNavigator {
  
  var toSignIn_Called = false
  func toSignIn() {
    toSignIn_Called = true
  }
  
  var toHome_Called = false
  func toHome() {
    toHome_Called = true
  }
  
  var toTerms_Called = false
  func terms() {
    toTerms_Called = true
  }

}

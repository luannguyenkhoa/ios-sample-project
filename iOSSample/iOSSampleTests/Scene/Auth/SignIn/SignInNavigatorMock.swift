//
//  SignInNavigatorMock.swift
//  iOSSampleTests
//
//  Copyright © 2019 Agility. All rights reserved.
//

@testable import iOSSample

class SignInNavigatorMock: SignInNavigator {
  
  var toSignIn_Called = false
  func toSignIn() {
    toSignIn_Called = true
  }

  var toSignUp_Called = false
  func toSignUp() {
    toSignUp_Called = true
  }
  
  var toForgotPassword_Called = false
  func toForgotPassword() {
    toForgotPassword_Called = true
  }
  
  var toHome_Called = false
  func toHome() {
    toHome_Called = true
  }
}

//
//  SignInAPIMock.swift
//  iOSSampleTests
//
//  Copyright © 2019 Agility. All rights reserved.
//

import ServiceKit
import RxSwift

class AuthUseCaseMock: AuthUseCase {
  
  var signIn_Called = false
  var signUp_Called = false
  var logout_Called = false
  
  var req_ReturnValue: APIResponse<User> = .completed
  
  func signIn(email: String, pwd: String) -> Observable<APIResponse<User>> {
    signIn_Called = true
    return Observable.just(req_ReturnValue)
  }
  
  func signUp(email: String, pwd: String, firstName: String, lastName: String) -> Observable<APIResponse<User>> {
    signUp_Called = true
    return Observable.just(req_ReturnValue)
  }
  
  func logout() {
    logout_Called = true
  }
  
}

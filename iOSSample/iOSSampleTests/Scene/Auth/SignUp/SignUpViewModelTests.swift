//
//  SignUpViewModelTests.swift
//  iOSSampleTests
//
//  Copyright © 2019 Agility. All rights reserved.
//

@testable import iOSSample
import XCTest
import RxSwift
import RxCocoa
import RxBlocking
import ServiceKit

class SignUpViewModelTests: XCTestCase {
  
  var viewModel: SignUpViewModel!
  var navigator: SignUpNavigatorMock!
  var useCaseMock: AuthUseCaseMock!
  
  var disposeBag: DisposeBag!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    super.setUp()
    
    navigator = SignUpNavigatorMock()
    useCaseMock = AuthUseCaseMock()
    viewModel = SignUpViewModel(navigator: navigator, authUseCase: useCaseMock)
    disposeBag = DisposeBag()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  func testSignUpInvoked() {
    
    let press = PublishSubject<Void>()
    _ = viewModel.transform(input: createInput(email: Driver.just("abc@gmail.com"),
                                               press: press.asDriver(())))
    useCaseMock.req_ReturnValue = .next(user())
    press.onNext(())
    
    XCTAssertTrue(navigator.toHome_Called)
  }
  
  func testTracking() {
    let press = PublishSubject<()>()
    let output = viewModel.transform(input: createInput(email: Driver.just("abc@gmail.com"),
                                                        press: press.asDriver(())))
    let expectedExecuting = [true, false]
    var actualExecuting = [Bool]()
    
    /// Collect result with ignore 2 very first emittions, it means bypass the initial values
    output.executing.skip(2).do(onNext: { actualExecuting.append($0) },
                                onSubscribe: { actualExecuting.append(true) })
      .drive().disposed(by: disposeBag)
    
    /// Fire an Press action
    press.onNext(())
    
    /// Compare expected and actual results
    XCTAssertEqual(actualExecuting, expectedExecuting)
  }
  
  func testAuthError() {
    
    let press = PublishSubject<()>()
    let output = viewModel.transform(input: createInput(email: Driver.just("abc@gmail.com"),
                                                        press: press.asDriver(())))
    useCaseMock.req_ReturnValue = .error(APIError(code: 400, message: "Unknown"))
    output.error.drive().disposed(by: disposeBag)
    press.onNext(())
    
    let error = try! output.error.toBlocking().first()!
    
    XCTAssertFalse(navigator.toHome_Called)
    XCTAssertNotNil(error)
    XCTAssertEqual(error?.message, "Unknown")
  }
  
  func testOtherActions() {
    
    let terms = PublishSubject<Void>()
    let signIn = PublishSubject<Void>()
    _ = viewModel.transform(input: createInput(terms: terms.asDriver(()), signin: signIn.asDriver(())))
    
    terms.onNext(())
    XCTAssertTrue(navigator.toTerms_Called)
    
    signIn.onNext(())
    XCTAssertTrue(navigator.toSignIn_Called)
  }
  
  private func createInput(email: Driver<String> = Driver.just(""),
                           press: Driver<Void> = Driver.never(),
                           terms: Driver<Void> = Driver.never(),
                           signin: Driver<Void> = Driver.never()) -> SignUpViewModel.Input {
    return SignUpViewModel.Input(email: email, signin: signin, terms: terms, press: press)
  }
  
  private func user() -> User {
    return User(username: "anv", email: "abc@gmail.com", userId: 1102)
  }
}

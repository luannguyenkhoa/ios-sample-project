//
//  HomeViewModelTests.swift
//  iOSSampleTests
//
//  Copyright © 2019 Agility. All rights reserved.
//

import XCTest
@testable import iOSSample
import RxSwift
import RxCocoa
import RxBlocking
import ServiceKit

class HomeViewModelTests: XCTestCase {
  
  var viewModel: HomeViewModel!
  var navigator: HomeNavigatorMock!
  var useCaseMock: PostUseCaseMock!
  
  var disposeBag: DisposeBag!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    super.setUp()
    
    navigator = HomeNavigatorMock()
    useCaseMock = PostUseCaseMock()
    viewModel = HomeViewModel(navigator: navigator, postUseCase: useCaseMock)
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
  
  func testFetchPosts() {
    
    let fetch = PublishSubject<Enum.FetchType>()
    let output = viewModel.transform(input: createInput(fetch: fetch.asDriver(.refresh)))
    useCaseMock.fetch_ReturnValues = .next(([fakeItem()], nil))
    
    /// Act
    output.posts.drive().disposed(by: disposeBag)
    fetch.onNext(.refresh)
    
    /// Assert
    let posts = try! output.posts.toBlocking().first()!
    XCTAssertEqual(posts.count, 1)
  }
  
  func testErrorEmitter() {
    
    let fetch = PublishSubject<Enum.FetchType>()
    let output = viewModel.transform(input: createInput(fetch: fetch.asDriver(.refresh)))
    useCaseMock.fetch_ReturnValues = .error(APIError(code: 201, message: "Unauthorized User", title: ""))
    
    output.error.drive().disposed(by: disposeBag)
    fetch.onNext(.refresh)
    
    /// Assert
    let error = try! output.error.toBlocking().first()!
    XCTAssertNotNil(error)
    XCTAssertEqual(error?.message, "Unauthorized User")
  }
  
  func testExecutingEmitter() {
    
    let fetch = PublishSubject<Enum.FetchType>()
    let output = viewModel.transform(input: createInput(fetch: fetch.asDriver(.refresh)))
    let expectedExecuting = [true, false]
    var actualExecuting = [Bool]()
    
    /// Collect result with ignore 2 very first emittions, it means bypass the initial values
    output.fetching.skip(2).do(onNext: { actualExecuting.append($0) },
                                onSubscribe: { actualExecuting.append(true) })
      .drive().disposed(by: disposeBag)
    
    /// Fire an Press action
    fetch.onNext(.refresh)
    
    /// Compare expected and actual results
    XCTAssertEqual(actualExecuting, expectedExecuting)
  }
  
  func testPagination() {
    
    let fetch = PublishSubject<Enum.FetchType>()
    let output = viewModel.transform(input: createInput(fetch: fetch.asDriver(.refresh)))
    useCaseMock.fetch_ReturnValues = .next((Array(repeating: fakeItem(), count: 10), "ABCXYZ"))
    
    output.posts.drive().disposed(by: disposeBag)
    fetch.onNext(.paginize)
    
    var posts = try! output.posts.toBlocking().first()!
    XCTAssertNil(useCaseMock.fetch_Pagination_Token)
    XCTAssertEqual(posts.count, 10)
    
    useCaseMock.fetch_ReturnValues = .next((Array(repeating: fakeItem(), count: 10), "ABCXYZ2"))
    fetch.onNext(.paginize)
    posts = try! output.posts.toBlocking().first()!
    XCTAssertEqual(useCaseMock.fetch_Pagination_Token, "ABCXYZ")
    XCTAssertEqual(posts.count, 20)
  }
  
  private func createInput(fetch: Driver<Enum.FetchType> = Driver.never(),
                           willAppear: Driver<Void> = Driver.never(),
                           selectIndex: Driver<Int> = Driver.never()) -> HomeViewModel.Input {
    return HomeViewModel.Input(fetch: fetch, willAppear: willAppear, selectIndex: selectIndex)
  }
  
  private func fakeItem() -> PostItem {
    return PostItem(id: UUID().uuidString, author: "ajdjd", version: 1)
  }
}

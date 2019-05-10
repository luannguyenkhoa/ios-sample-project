import XCTest
@testable import ServiceKit
import RxTest
import RxBlocking
import RxSwift
import RxCocoa
import OHHTTPStubs

class AuthAPITest: XCTestCase {
  
  private let disposeBag = DisposeBag()
  private var queue: SchedulerType!
  private var scheduler: TestScheduler!
  private var authUseCase: AuthUseCase!
  let profile: (Int) -> [String: Any] = { ["id": 1, "username": "abcAZS", "first_name": "Andy", "last_name": "Luan", "email": "user\($0)@gmail.com", "apiKey": "roefDAASkdda!@#ASDAdASDAweQWE!@aASDAA\($0)"] as [String : Any] }
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    queue = ConcurrentDispatchQueueScheduler(qos: .background)
    scheduler = TestScheduler(initialClock: 0)
    authUseCase = APIProvider.makeAuthAPI(baseURL: "https://www.google.com/")
    
    OHHTTPStubs.onStubActivation { (request: URLRequest, stub: OHHTTPStubsDescriptor, response: OHHTTPStubsResponse) in
      print("[OHHTTPStubs] Request to \(request.url!) has been stubbed with \(String(describing: stub.name))")
    }
    
    /// Stub authorization apis
    stub(condition: isPath("/login") && isMethodPOST()) { (req) in
      return OHHTTPStubsResponse(jsonObject: self.profile(1), statusCode: 200, headers: nil)
    }.name = "Stub Login API"
    
    stub(condition: isPath("/signup") && isMethodPOST()) { (req) in
      return OHHTTPStubsResponse(jsonObject: self.profile(1), statusCode: 200, headers: nil)
    }.name = "Stub SignUp API"
    
    stub(condition: isPath("/logout") && isMethodPOST()) { (req) in
      return OHHTTPStubsResponse(jsonObject: [:], statusCode: 200, headers: nil)
    }.name = "Stub Logout API"
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    OHHTTPStubs.removeAllStubs()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testAuth() {
    let results = scheduler.createObserver(APIResponse<User>.self)
    scheduler.createColdObservable([
        .next(10, self.authUseCase!.signUp(email: "abc@a.com", pwd: "12345678", firstName: "and", lastName: "or")),
        .next(20, self.authUseCase!.signIn |> ("abc@a.com", "12345678"))
      ]).map({ try! $0.toBlocking().first()! })
    .bind(to: results).disposed(by: disposeBag)
    
    scheduler.start()
    
    let expectedUser = try! JSONDecoder().decode(User.self, from: ServiceKit.Utility.serializeJSON(profile(1))!)
    
    XCTAssertEqual(results.events, [
      .next(10, .next(expectedUser)),
      .next(20, .next(expectedUser)),
      ])
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}

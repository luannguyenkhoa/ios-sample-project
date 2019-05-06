import XCTest
@testable import ServiceKit
import RxTest
import RxBlocking
import RxSwift
import RxCocoa
import OHHTTPStubs

class SampleAPITest: XCTestCase {
  
  private let disposeBag = DisposeBag()
  private var queue: SchedulerType!
  private var scheduler: TestScheduler!
  private var api: SampleAPI!
  let profile: (Int) -> [String: Any] = { ["id": 1, "username": "abcAZS", "first_name": "Andy", "last_name": "Luan", "email": "user\($0)@gmail.com", "apiKey": "roefDAASkdda!@#ASDAdASDAweQWE!@aASDAA\($0)"] as [String : Any] }
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    queue = ConcurrentDispatchQueueScheduler(qos: .background)
    scheduler = TestScheduler(initialClock: 0)
    api = APIProvider.makeSampleAPI(baseURL: "https://www.google.com/")
    
    let users = (1...10).map{(email: "user\($0)@gmail.com", password: "abc\($0)23@aaaa", profile: profile($0))}
    var userNum = users.count
    
    OHHTTPStubs.onStubActivation { (request: URLRequest, stub: OHHTTPStubsDescriptor, response: OHHTTPStubsResponse) in
      print("[OHHTTPStubs] Request to \(request.url!) has been stubbed with \(String(describing: stub.name))")
    }
    
    /// Stub authorization apis
    stub(condition: isPath("/login") && isMethodPOST()) { (req) in
      guard let body = req.httpBody else {
        return OHHTTPStubsResponse(jsonObject: ["error": "Missing request body"], statusCode: 400, headers: nil)
      }
      guard let json: [String: Any] = ServiceKit.Utility.serializeData(body) else {
        return OHHTTPStubsResponse(jsonObject: ["error": "Request body must be formatted in JSON type"], statusCode: 400, headers: nil)
      }
      guard let email = json["email"] as? String, let pwd = json["password"] as? String else {
        return OHHTTPStubsResponse(jsonObject: ["error": "Missing email or password"], statusCode: 400, headers: nil)
      }
      guard pwd.count >= 8 else {
        return OHHTTPStubsResponse(jsonObject: ["error": "Incorrect password length"], statusCode: 400, headers: nil)
      }
      guard let user = users.find({ $0.email == email && $0.password == pwd }) else {
        return OHHTTPStubsResponse(jsonObject: ["error": "User is not exist"], statusCode: 400, headers: nil)
      }
      return OHHTTPStubsResponse(jsonObject: user.profile, statusCode: 200, headers: nil)
    }.name = "Stub Login API"
    
    stub(condition: isPath("signup/") && isMethodPOST()) { (req) in
      guard let body = req.httpBody else {
        return OHHTTPStubsResponse(jsonObject: ["error": "Missing request body"], statusCode: 400, headers: nil)
      }
      guard let json: [String: Any] = ServiceKit.Utility.serializeData(body) else {
        return OHHTTPStubsResponse(jsonObject: ["error": "Request body must be formatted in JSON type"], statusCode: 400, headers: nil)
      }
      guard let email = json["email"] as? String, let pwd = json["password"] as? String else {
        return OHHTTPStubsResponse(jsonObject: ["error": "Missing email or password"], statusCode: 400, headers: nil)
      }
      guard pwd.count >= 8 else {
        return OHHTTPStubsResponse(jsonObject: ["error": "Incorrect password length"], statusCode: 400, headers: nil)
      }
      guard users.find({ $0.email == email && $0.password == pwd }).isNil else {
        return OHHTTPStubsResponse(jsonObject: ["error": "User does exist"], statusCode: 400, headers: nil)
      }
      userNum += 1
      return OHHTTPStubsResponse(jsonObject: self.profile(userNum-1), statusCode: 200, headers: nil)
    }.name = "Stub SignUp API"
    
    stub(condition: isPath("logout/") && isMethodPOST()) { (req) in
      guard let header = req.allHTTPHeaderFields, let token = header["Authorization"] else {
        return OHHTTPStubsResponse(jsonObject: ["error": "Missing token"], statusCode: 401, headers: nil)
      }
      guard users.find({ $0.profile["apiKey"] as? String == token }).notNil else {
        return OHHTTPStubsResponse(jsonObject: ["error": "User not found"], statusCode: 401, headers: nil)
      }
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
  
  func testLogin() {
    let cases = [(email: "user1@gmail.com", pwd: "abc23@aaaa"), (email: "aa@g.com", pwd: "ad"),
                 (email: "aa@g.com", pwd: "abc123@aaaa"), (email: "user2@gmail.com", pwd: "abc223@aaaa")]
    let results = scheduler.createObserver(APIResponse<User>.self)
    scheduler.createColdObservable([
        .next(10, self.api.signIn |> cases[0]),
        .next(20, self.api.signIn |> cases[1]),
        .next(30, self.api.signIn |> cases[2]),
        .next(40, self.api.signIn |> cases[3]),
      ]).map({ try! $0.toBlocking().first()! })
      .do(onNext: { (res) in
        print(res)
      })
    .bind(to: results).disposed(by: disposeBag)
    
    scheduler.start()
    
    let expectedUser = try! JSONDecoder().decode(User.self, from: ServiceKit.Utility.serializeJSON(profile(2))!)
    
    XCTAssertEqual(results.events, [
      .next(10, .error(nil)),
      .next(20, .error(nil)),
      .next(30, .error(nil)),
      .next(40, .next(expectedUser)),
      ])
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}

import Alamofire
import RxSwift

public protocol AuthUseCase {
  
  func signIn(email: String, pwd: String) -> Observable<APIResponse<User>>
  func signUp(email: String, pwd: String, firstName: String, lastName: String) -> Observable<APIResponse<User>>
  func logout()
}

private enum AuthEndpoint: Endpoint {
  
  case signIn(email: String, password: String)
  case signUp(email: String, pwd: String, firstName: String, lastName: String)
  case logout
  
  var path: String {
    switch self {
    case .signIn:  return "login/"
    case .signUp:  return "signup/"
    case .logout:  return "logout/"
    }
  }
  
  var parameters: JSON? {
    switch self {
    case .signIn(let usr, let pwd):      return ["email": usr, "password": pwd]
    case .signUp(let email, let password, let firstName, let lastName):
      return ["email": email, "password": password, "first_name": firstName, "last_name": lastName]
    default: return nil
    }
  }
  
  var encoding: ParameterEncoding {
    return JSONEncoding.default
  }
  
}

public struct AuthAPI: AuthUseCase, AuthMapping {
  
  /// MARK: - Internal properties
  private let network: Network<User>
  let jsonDecoder: JSONDecoder
  private typealias API = AuthEndpoint
  private let reachability: ReachabilityService
  
  init(network: Network<User>) {
    self.network = network
    jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .formatted(DateFormat.formal.dateFormatter)
    // swiftlint:disable force_try
    reachability = try! DefaultReachabilityService()
  }
  
  /// MARK: - Auth
  public func signIn(email: String, pwd: String) -> Observable<APIResponse<User>> {
    return network.post(endpoint: API.signIn(email: email, password: pwd)).map({ self.map() |> (nil, $0) })
  }
  
  public func signUp(email: String, pwd: String, firstName: String, lastName: String) -> Observable<APIResponse<User>> {
    return network.post(endpoint: API.signUp(email: email, pwd: pwd, firstName: firstName, lastName: lastName)).map({ self.map() |> (nil, $0) })
  }
  
  public func logout() {
    network.request(endpoint: API.logout)
  }
}

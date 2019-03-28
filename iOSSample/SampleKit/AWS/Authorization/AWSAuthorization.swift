import AWSMobileClient
import RxSwift

public enum State {
  case auth, unauth, fail
}

public struct AWSAuthorization {
  
  public static var shared = AWSAuthorization()
  public var clientID = ""
  
  public func intialize(_ completion: @escaping (State) -> Void) {
    AWSMobileClient.sharedInstance().initialize { (state, err) in
      guard let state = state else {
        completion(.fail)
        return
      }
      switch state {
      case .signedIn:
        if UserDefaults.standard.bool(forKey: "InitializedApp") {
          completion(.auth)
          self.fetchTokens()
          self.regiterServices()
        } else {
          self.signOut()
          completion(.unauth)
        } case .signedOut, .signedOutFederatedTokensInvalid, .signedOutUserPoolsTokenInvalid:
        completion(.unauth)
      default: completion(.fail)
      }
      /// Flag the app is initialized
      UserDefaults.standard.set(true, forKey: "InitializedApp")
    }
  }
  
  public func intercept(_ app: UIApplication, url: URL, source: String?, annotation: Any) -> Bool {
    return AWSMobileClient.sharedInstance().interceptApplication(app, open: url, sourceApplication: source, annotation: annotation)
  }
  
  public func autoRefreshUserToken(in obj: AnyObject) {
    AWSMobileClient.sharedInstance().addUserStateListener(obj) { (state, info) in
      switch state {
      case .signedOutUserPoolsTokenInvalid:
        /// Once receive an invalid token signal, should automatically refresh it silently
        let email = UDKey.User.email.value ?? ""
        let pwd = UDKey.User.password.value ?? ""
        AWSMobileClient.sharedInstance().signIn(username: email, password: pwd, completionHandler: { (_, err) in
          if let err = err {
            d_print("Refresh error: \(err.localizedDescription)")
          }
        })
      default:
        d_print("User state - \(state)")
      }
    }
  }
  
  public func signUp(email: String, pwd: String, attributes: [String: String] = [:]) -> Observable<NetworkResponse<Bool>> {
    return .create({ (observer) in
      
      AWSMobileClient.sharedInstance().signUp(username: email, password: pwd, userAttributes: attributes) { (res, err) in
        defer { observer.onCompleted() }
        if let res = res {
          switch res.signUpConfirmationState {
          case .confirmed:
            self.cacheUser(confirmed: true, email: email, pwd: pwd)
            observer.onNext(.next(true))
          case .unconfirmed:
            self.cacheUser(confirmed: false, email: email, pwd: pwd)
            observer.onNext(.next(false))
          default: observer.onNext(.error(NetworkError(AWSError.unexpectedError.desc)))
          }
        } else if let error = err as? AWSMobileClientError {
          switch(error) {
          case .usernameExists(let message),
               .userNotConfirmed(let message),
               .invalidParameter(let message):
            observer.onNext(.error(NetworkError(message)))
          default:
            observer.onNext(.error(NetworkError(AWSError.unexpectedError.desc)))
          }
        }
      }
      return Disposables.create()
    })
  }
  
  public func signIn(email: String, password: String) -> Observable<NetworkResponse<Bool>> {
    return .create { (observer) in
      AWSMobileClient.sharedInstance().signIn(username: email, password: password) { (res, err) in
        defer { observer.onCompleted() }
        if let res = res {
          switch res.signInState {
          case .signedIn:
            self.cacheUser(confirmed: true, email: email, pwd: password)
            self.fetchTokens()
            self.regiterServices()
            observer.onNext(.next(true))
          default:
            observer.onNext(.error(NetworkError(AWSError.unexpectedError.desc)))
          }
        } else if let error = err as? AWSMobileClientError {
          switch error {
          case .notAuthorized(let msg),
               .userNotFound(let msg):
            observer.onNext(.error(NetworkError(msg)))
          case .userNotConfirmed:
            self.cacheUser(confirmed: false, email: email, pwd: password)
            observer.onNext(.next(false))
          case .invalidState:
            self.signOut()
            observer.onNext(.error(NetworkError(AWSError.unexpectedError.desc)))
          default: observer.onNext(.error(NetworkError(AWSError.unexpectedError.desc)))
          }
        } else {
          observer.onNext(.error(NetworkError(AWSError.unexpectedError.desc)))
        }
      }
      return Disposables.create()
    }
  }
  
  public func confirmCode(_ code: String, email: String) -> Observable<NetworkResponse<Bool>> {
    return .create { observer in
      AWSMobileClient.sharedInstance().confirmSignUp(username: email, confirmationCode: code) { (res, err) in
        defer { observer.onCompleted() }
        if let res = res {
          switch res.signUpConfirmationState {
          case .confirmed:
            /// Reminder: After confirming code successfully, we should call signIn to initilize user's session and get tokens
            UDKey.User.confirmed.set(true)
            observer.onNext(.next(true))
          default:
            observer.onNext(.error(NetworkError(AWSError.unexpectedError.desc)))
          }
        } else {
          observer.onNext(.error(NetworkError(AWSError.unexpectedError.desc)))
        }
      }
      return Disposables.create()
    }
  }
  
  public func resendCode(email: String) -> Observable<NetworkResponse<Bool>> {
    return .create { observer in
      AWSMobileClient.sharedInstance().resendSignUpCode(username: email) { res, err in
        /// defer to make sure of onCompleted getting fired at the end
        defer { observer.onCompleted() }
        /// Determine the result and error
        if res?.codeDeliveryDetails?.deliveryMedium == .email {
          observer.onNext(.next(true))
        } else if let error = err as? AWSMobileClientError {
          switch error {
          case .invalidParameter(let message),
               .userNotFound(let message):
            observer.onNext(.error(NetworkError(message)))
          default:
            observer.onNext(.error(NetworkError(AWSError.unexpectedError.desc)))
          }
        }
      }
      return Disposables.create()
    }
  }
  
  /// Get user's attributes and decode user's encrypted private key from response then send back to listeners
  public func getAttributes(_ completion: @escaping (String) -> Void) {
    self.getIdentityId()
    AWSMobileClient.sharedInstance().getUserAttributes { attrs, err in
      // Decode the response to get necessary attributes
      d_print(attrs ?? [:])
    }
  }
  
  private func getIdentityId() {
    AWSMobileClient.sharedInstance().getIdentityId().continueWith { (task) in
      if let clientId = task.result as String? {
        AWSAuthorization.shared.clientID = clientId
      }
      return nil
    }
  }
  
  internal func cacheUser(confirmed: Bool, email: String, pwd: String) {
    /// Caching something if needed
    let username = AWSMobileClient.sharedInstance().username ?? email
    zip([username, pwd, confirmed], [UDKey.User.email, UDKey.User.password, UDKey.User.confirmed]).forEach({ $0.1.set($0.0) })
    UDKey.User.userId.set(username)
  }
  
  public func fetchTokens(_ completion: ((String?) -> Void)? = nil) {
    /// Retreive user's tokens and cache access token in local storage
    AWSMobileClient.sharedInstance().getTokens { (tokens, err) in
      if let token = tokens?.accessToken?.tokenString {
        UDKey.User.token.set(token)
      }
      completion?(tokens?.accessToken?.tokenString)
    }
  }
  
  public func signOut() {
    /// Clean up all local caching data
    UDKey<Any>.User.clean()
    
    /// FIXME: should consider to eliminate these code if no need to clean AppSync local db
    /// Remove AppSync caching db
    try? FileManager.default.removeItem(at: AppSynClient.shared.dbURL)
    
    /// Should remove all caching data here
    AWSMobileClient.sharedInstance().signOut()
  }
  
  /// Sign an AWS url to get access permission by taking use of AWS Signature V4: https://docs.aws.amazon.com/general/latest/gr/signature-version-4.html
  ///
  /// - Parameter url: sign url
  /// - Parameter service: specified AWS service for signing, default is S3
  /// - Returns: an url request with signed url
  public func signRequest(url: URL, serive: AWSServiceType = .S3) -> URLRequest {
    let credentials = AWSServiceManager.default()?.defaultServiceConfiguration.credentialsProvider
    let signature = AWSSignatureV4Signer(credentialsProvider: credentials!, endpoint: AWSEndpoint(region: .USEast1, service: serive, url: url))
    let date = (NSDate.aws_clockSkewFixed()! as NSDate).aws_stringValue(AWSDateISO8601DateFormat2)!
    let req = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
    req.httpMethod = "GET"
    req.allHTTPHeaderFields = ["Content-Type": "application/x-www-form-urlencoded", "X-Amz-Date": date]
    signature?.interceptRequest(req)?.continueWith(block: { _ in return nil })
    return req as URLRequest
  }
  
  private func regiterServices() {
    // Create a service configuration
    guard let serviceConfiguration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: AWSMobileClient.sharedInstance()) else { return }
    /// Take advantage of AWSMobileClient to register the default service configuration
    AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
  }
}

// Event tracking gathering
public enum EventTracking {
  
  case login
  case signup
  case openApp
  
  public var key: String {
    switch self {
    case .login: return "E_LOGIN"
    case .signup: return "E_SIGNUP"
    case .openApp: return "E_OPEN_APP"
    }
  }
  
  public func tracking() {
    /// Calling Third Parties tracking funcions here
  }
  
  public static func analyticsUsers() {
    /// Initialize Event Tracking services with user's attributes
  }
}

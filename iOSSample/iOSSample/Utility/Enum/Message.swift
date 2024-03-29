import Foundation

enum Message: String {
  case common
  public var desc: String {
    switch self {
    case .common: return "message-common".localized()
    }
  }
  
  enum Error {
    case network
    var desc: String {
      switch self {
      case .network: return "message-error".localized(comment: "Please try again later. Make sure you have good internet connection. If this error persist please contact support.")
      }
    }
  }
  
  enum SignUp: Int {
    case emailInvalid = 0, pwdInvalid, fNameInvalid, lNameInvalid
    var desc: String {
      switch self {
      case .pwdInvalid: return "message-signup-password-invalid".localized(comment: "Please input your password")
      case .fNameInvalid: return "message-signup-firstname-invalid".localized(comment: "Please input your first name")
      case .lNameInvalid: return "message-signup-lastname-invalid".localized(comment: "Please input your last name")
      case .emailInvalid: return "message-signup-email-invalid".localized(comment: "Please input your email")
      }
    }
  }
}

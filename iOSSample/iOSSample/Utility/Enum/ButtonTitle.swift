import Foundation

enum ButtonTitle {
  
  enum Common: String {
    case ok = "OK"
    
    var title: String {
      return self.rawValue.localized(comment: "")
    }
  }
  
  enum Alert {
    case cancelUpdate
    case getUpdated
    var title: String {
      switch self {
      case .cancelUpdate: return "Skip"
      case .getUpdated:   return "Update"
      }
    }
  }
}

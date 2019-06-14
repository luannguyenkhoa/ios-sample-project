import ServiceKit

public enum ViewText {
  
  enum Button {
    
    enum Common: String {
      case ok
      var title: String {
        switch self {
        case .ok: return "view-text-button-common-ok".localized(comment: "OK")
        }
      }
    }
  }
  
  enum Label {
    
    enum Account {
      case account, signedin
      var desc: String {
        switch self {
        case .account:      return "view-text-label-account-account".localized(comment: "Account")
        case .signedin:     return "view-text-label-account-signedin".localized(comment: "Signed In")
        }
      }
    }
  }

}

import UIKit

enum Enum {
  
  enum NotiKey: String {
    
    case RegisterNotificationDidFinish
    case SignOut

    var name: Notification.Name {
      return Notification.Name(rawValue)
    }
  }
  
  enum NavigationType {
    
    case push
    case present
  }
  
  enum DeviceSize {
    case small, medium, large
    var valid: Bool {
      switch self {
      case .small: return UIScreen.main.bounds.height <= 568
      case .medium: return UIScreen.main.bounds.height <= 667
      default: return UIScreen.main.bounds.height > 667
      }
    }
    
  }
}

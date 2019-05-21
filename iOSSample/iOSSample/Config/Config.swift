import UIKit

enum Configs {
  
  /// Global constant properties
  case apiURL
  
  private var appSettings: [AnyHashable: Any]? {
    guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
      let plist = NSDictionary(contentsOfFile: path),
      let appSettings = plist["AppSettings"] as? [AnyHashable: Any] else {
        return nil
    }
    return appSettings
  }
  
  var value: String {
    switch self {
    case .apiURL:
      return appSettings?["ApiURL"] as? String ?? ""
    }
  }
  
}

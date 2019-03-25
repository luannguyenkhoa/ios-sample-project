enum Configs: String {
  
  /// Global constant properties
  #if DEV
    case apiURL = ""
  #elseif STAGING
    case apiURL = ""
  #else
    case apiURL = ""
  #endif
  
  var value: String {
    return self.rawValue
  }
  
}

import ServiceKit

extension Validation {
  
  static func password(_ pwd: String) -> Bool {
    // Password should be at least 8 characters long
    return pwd.count >= 6
  }
}

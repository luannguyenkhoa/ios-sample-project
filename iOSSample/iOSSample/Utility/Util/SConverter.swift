import SampleKit

extension Converter {
  
  static func convertAddress(_ address: String) -> String {
    let components = address.components(separatedBy: ",")
    guard components.count > 2 else { return address }
    return components[0...2].joined(separator: ",")
  }
  
  static func toBool(_ val: Any) -> Bool {
    return val as? Bool ?? false
  }
  
  static func toString(_ val: Any) -> String {
    return val as? String ?? ""
  }
}

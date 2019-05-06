import ServiceKit

extension Utility {
  
  static func formatCurrency(text: String) -> String {
    if text.count == 1, text.first == "$" {
      return ""
    }
    if !text.isEmpty, text.first != "$" {
      return "$" + text
    }
    return text
  }
  
  static func getCurrency(tfs: [UITextField]) -> [Float?] {
    return tfs.map { (tf) in
      var val = tf.text ?? ""
      if !val.isEmpty, val.first == "$" {
        val.remove(at: val.startIndex)
      }
      if let infloat = Float(val) {
        return Float(Converter.truncatedFloat(infloat))
      }
      return nil
    }
  }
  
  static func divide(val: Float, for div: Float) -> Float {
    return div == 0 ? 0 : val/div
  }
  
  static func appVersion() -> String? {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
  }
}

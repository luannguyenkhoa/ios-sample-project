//
//  File.swift
//  ServicePlatform
//
//

import Foundation

public extension String {

  /// MARK: Subscripts
  public subscript(value: PartialRangeUpTo<Int>) -> Substring {
    get {
      return self[..<index(startIndex, offsetBy: value.upperBound)]
    }
  }

  public subscript(value: PartialRangeThrough<Int>) -> Substring {
    get {
      return self[...index(startIndex, offsetBy: value.upperBound)]
    }
  }

  public subscript(value: PartialRangeFrom<Int>) -> Substring {
    get {
      return self[index(startIndex, offsetBy: value.lowerBound)...]
    }
  }

  public func substring(to: Int) -> String {
    return String(self[...min(count - 1, to)])
  }

  public func substring(from: Int) -> String {
    return String(self[max(0, from)...])
  }

  /// MARK: Extended functions
  public func trim() -> String {
    return self.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  /// Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
  public func truncate(length: Int, trailing: String = "") -> String {
    return (self.count > length) ? (String(self.prefix(length)) + trailing) : self
  }

  /// Determine whether the given value in string type is Zero or not
  public var isZero: Bool {
    if let num = self.components(separatedBy: " ").first, let inFloat = Float(num), inFloat == 0.0 {
      return true
    }
    return false
  }

  public func encodeURL() -> URL? {
    if let encodedURL = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
      return URL(string: encodedURL)
    }
    return nil
  }

  public func nsRange(from range: Range<Index>) -> NSRange {
    if let lower = UTF16View.Index(range.lowerBound, within: utf16),
      let upper = UTF16View.Index(range.upperBound, within: utf16) {
      return NSRange(location: utf16.distance(from: utf16.startIndex, to: lower), length: utf16.distance(from: lower, to: upper))
    }
    return NSRange()
  }
  
  public func isNumber() -> Bool {
    return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
  }
  
  public func underlineString(underlineString: String? = nil, color: UIColor? = nil) -> NSAttributedString {
    let attributedText = NSMutableAttributedString(string: self)
    let range = (self as NSString).range(of: underlineString ?? self)
    attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
    if let color = color{
      attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    return attributedText
  }
  
  public func localized(comment: String = "") -> String {
    return NSLocalizedString(self, comment: comment)
  }
  
  public func viewController<T: UIViewController>(_ viewController: T.Type) -> T {
    return UIStoryboard(storyboard: self).instantiate(viewController)
  }
}

public extension Optional where Wrapped == String {
  
  var wrap: String {
    return self ?? ""
  }
  
  public func isNilOrEmpty() -> Bool {
    return isNil || self == ""
  }
}
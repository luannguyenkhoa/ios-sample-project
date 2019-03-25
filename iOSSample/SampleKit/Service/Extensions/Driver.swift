//
//  Button.swift
//  ServicePlatform
//
//

import RxSwift
import RxCocoa

public extension UIButton {

  /// Convenient function for making a Rx driver of Button
  ///
  /// - Returns: Rx driver
  public func driver() -> Driver<Void> {
    return rx.tap.asDriver()
  }
}

public extension UITextField {
  
  /// Convenient function for making a Rx driver of textfield
  ///
  /// - Returns: Rx driver
  public func driver() -> Driver<String> {
    return rx.text.orEmpty.asDriver()
  }
  
  public func driveText() -> Driver<String> {
    return Driver.merge(rx.observe(String.self, "text").map({ $0 ?? "" }).asDriver(""), driver())
  }
}


public extension UILabel {
  
  public func observable() -> Observable<String?> {
    return rx.observe(String.self, "text")
  }
  
  /// Convenient function for making a Rx driver of label
  ///
  /// - Returns: Rx driver
  public func driver() -> Driver<String?> {
    return rx.observe(String.self, "text").asDriver(nil)
  }
}

public extension UITextView {
  
  /// Convenient function for making a Rx driver of textview
  ///
  /// - Returns: Rx driver
  public func driver() -> Driver<String> {
    return rx.text.orEmpty.asDriver()
  }
  
  public func driveText() -> Driver<String> {
    return Driver.merge(rx.observe(String.self, "text").map({ $0 ?? "" }).asDriver(""), driver())
  }
}

public extension UISwitch {
  
  /// Convenient function for making a Rx driver of switch 
  ///
  /// - Returns: Rx driver
  public func driver() -> Driver<Bool> {
    return rx.isOn.changed.asDriver()
  }
}

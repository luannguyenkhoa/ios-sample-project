//
// Account.swift
// iOSSample
//
//

import ServiceKit
import RxSwift

struct Account {
  
  static var singleton = Account()
  var user: User?
}

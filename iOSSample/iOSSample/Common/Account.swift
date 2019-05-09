//
// Account.swift
// iOSSample
//
// Copyright © 2019 Agility. All rights reserved.
//

import ServiceKit
import RxSwift

struct Account {
  
  static var singleton = Account()
  var user: User?
}

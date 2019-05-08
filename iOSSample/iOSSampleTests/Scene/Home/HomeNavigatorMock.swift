//
// HomeNavigatorMock.swift
// iOSSample
//
// Copyright © 2019 Agility. All rights reserved.
//

@testable import iOSSample
import ServiceKit

final class HomeNavigatorMock: HomeNavigator {
  
  var toHome_Called = false
  func toHome() {
    toHome_Called =  true
  }
  
  var toPostDetail_Called = false
  var toPostDetail_ReceivedArg: PostItem?
  func toPostDetail(post: PostItem) {
    toPostDetail_Called = true
    toPostDetail_ReceivedArg = post
  }

}

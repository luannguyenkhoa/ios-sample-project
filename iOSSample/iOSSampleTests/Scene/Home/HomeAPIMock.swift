//
// HomeAPIMock.swift
// iOSSample
//
// Copyright © 2019 Agility. All rights reserved.
//

import AWSAppSync
import ServiceKit
import RxSwift

final class PostUseCaseMock: PostUseCase {
  
  var updatePost_ReturnValue: APIResponse<(AppSynClient.PerformState, PostItem?)> = .completed
  func updatePost(post: PostBrief, onOptimistic: Bool) -> Observable<APIResponse<(AppSynClient.PerformState, PostItem?)>> {
    return .just(updatePost_ReturnValue)
  }
  
  var fetch_ReturnValues: APIResponse<(list: [PostItem], token: String?)> = .completed
  var fetch_Pagination_Token: String?
  func fetch(limit: Int?, token: String?, cachePolicy: CachePolicy) -> Observable<APIResponse<(list: [PostItem], token: String?)>> {
    fetch_Pagination_Token = token
    return .just(fetch_ReturnValues)
  }
  
  var fetchAllCache_ReturnValues = [PostItem]()
  func fetchAllCache() -> Observable<[PostItem]> {
    return .just(fetchAllCache_ReturnValues)
  }
  
  var create_ReturnValue: APIResponse<Bool> = .completed
  func create(post: PostBrief, onOptimistic: Bool) -> Observable<APIResponse<Bool>> {
    return .just(create_ReturnValue)
  }
  
  var subscribe_Called = false
  func subscribe<T>(for type: T, regression: ((Cancelable) -> Void)?) -> Observable<(ApolloStore.ReadWriteTransaction?, PostItem)> where T : GraphQLSubscription {
    subscribe_Called = true
    return .empty()
  }
}

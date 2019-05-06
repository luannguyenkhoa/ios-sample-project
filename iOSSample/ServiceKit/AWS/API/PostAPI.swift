import RxSwift
import AWSAppSync

public struct PostAPI {
  
  /// Start updating a post with new info and specifying whether needs to do UI optimistic for offline or not
  ///
  /// - Parameters:
  ///   - post: post with new info
  ///   - onOptimistic: flag to determine the UI optimistic approach
  /// - Returns: Response of request state and Item List object wrapped in a data streaming Observable
  static func updatePost(post: PostBrief, onOptimistic: Bool = true) -> Observable<APIResponse<(AppSynClient.PerformState, PostItem?)>> {
    let updating = UpdatePostInput(id: post.id, author: post.author, title: post.title, content: post.content, url: post.url, version: post.version)
    var files: [S3ObjectInput]?
    if let images = post.images?.compactMap({ $0 }), !images.isEmpty {
      files = images.map({ S3Manager.shared.makeS3Input(key: $0.key, localURI: $0.localUri ?? "") })
    }
    let mutation = UpdatePostMutation(input: updating, images: files)
    let lastTime = post.lastTime ?? 0
    
    return .create({ (observer) in
      
      AppSynClient.shared.appSyncClient?.perform(mutation: mutation, optimisticUpdate: { (transaction) in
        if onOptimistic {
          do {
            try transaction?.update(query: AllPostsQuery(), { (data: inout AllPostsQuery.Data) in
              let item = PostItem(snapshot: post.snapshot)
              if let idx = data.listPosts?.items?.firstIndex(where: { $0?.id == item.id }) {
                data.listPosts?.items?[idx] = item
              }
            })
          } catch let err {
            d_print(err)
          }
        }
      }, conflictResolutionBlock: { (state, task, response) in
        /// If the received data is available, being able to resolve the conflict
        if let state = state {
          /// Retrieve the current item on server
          let snapshot = UpdatePostMutation.Data.UpdatePost(snapshot: state)
          if (snapshot.lastTime ?? 0) > lastTime {
            var item = PostItem(id: snapshot.id, title: snapshot.title, author: snapshot.author,
                                content: snapshot.content, url: snapshot.url,
                                state: snapshot.state, version: snapshot.version)
            item.images = snapshot.images?.compactMap({ $0 }).map({ S3Manager.shared.s3(key: $0.key) })
            /// Let's update the local instead of forcing server update the item
            observer.onNext(.next((.updated, item)))
          } else {
            /// Reassign the latest version to get the version conflict resolved and then restart updating
            mutation.input.version = snapshot.version
            task?.set(result: mutation)
          }
        } else {
          /// Otherwise the object was deleted
          observer.onNext(.next((.deleted, nil)))
        }
      }, resultHandler: { (result, error) in
        
        defer {
          if result.isNil || result?.source == .server {
            observer.onCompleted()
          }
        }
        
        if let error = error as? AWSAppSyncClientError {
          d_print(error.errorDescription.wrap)
          observer.onNext(.error(APIError(error.errorDescription.wrap)))
          return
        }
        if let resultError = result?.errors {
          d_print(resultError)
          observer.onNext(.error(APIError(resultError.first?.errorDescription.wrap)))
          return
        }
        observer.onNext(.next((.completed, nil)))
      })
      return Disposables.create()
    })
  }
  
  /// Fetch data with pagination supported and cachePolity that specifies whether results should be fetched from the server or loaded from the local cache
  ///
  /// - Parameters:
  ///   - limit: specifies the number of items per each request
  ///   - token: a string that helps to determine it still has remaining items
  ///   - cachePolicy: specifies the way to fetch data
  /// - Returns: Response of item list and next token wrapped in a data streaming Observable
  static func fetch(limit: Int? = nil, token: String? = nil, cachePolicy: CachePolicy = .returnCacheDataAndFetch) -> Observable<APIResponse<(list: [PostItem], token: String?)>> {
    
    return .create{ (observer) in
      AppSynClient.shared.appSyncClient?.fetch(query: AllPostsQuery(limit: limit, nextToken: token), cachePolicy: cachePolicy) { (res, error) in
        
        /// End observable only when the last fetching gets finished
        defer {
          if res.isNil || res?.source == .server {
            observer.onCompleted()
          }
        }
        
        if let error = error as? AWSAppSyncClientError {
          d_print(error.localizedDescription)
          observer.onNext(.error(AppSynClient.errorHandling(error)))
          return
        }
        if let err = res?.errors?.first {
          d_print(err.errorDescription.wrap)
          observer.onNext(.error(APIError(code: 400, message: err.message)))
          return
        }
        /// Force completing the observable if no result
        guard let res = res else { return }
        observer.onNext(.next((res.data?.listPosts?.items?.compactMap({$0}) ?? [], res.data?.listPosts?.nextToken)))
        
      }
      return Disposables.create()
    }
  }
  
  /// Force fetching all Post items from local storage only
  ///
  /// - Returns: list of Post items wrapped in an observable for data streaming
  static func fetchAllCache() -> Observable<[PostItem]> {
    return .create { observer in
      
      AppSynClient.shared.appSyncClient?.fetch(query: AllPostsQuery(), cachePolicy: .returnCacheDataDontFetch) { res, error in
        /// Fetch all post from cache once only
        defer { observer.onCompleted() }
        
        if let error = error {
          d_print(error.localizedDescription)
          observer.onError(error)
          return
        }
        observer.onNext(res?.data?.listPosts?.items?.compactMap{$0} ?? [])
      }
      
      return Disposables.create()
    }
  }
  
  /// Perform a post creation from either server or both server and local if the corresponding flag is enabled
  ///
  /// - Parameters:
  ///   - post: a faking object that wraps inputted info
  ///   - onOptimistic: flag to determine that whether doing UI optimistic or not which normally related to offline mode supporting
  /// - Returns: an observable that wraps response of Bool value
  static func create(post: PostBrief, onOptimistic: Bool = true) -> Observable<APIResponse<Bool>> {
    let uniqueId = UUID().uuidString
    let images = post.images?.compactMap{ $0 }.map{ S3Manager.shared.makeS3Input(key: $0.key, localURI: $0.localUri.wrap) }
    
    let input = CreatePostInput(id: uniqueId, author: post.author, title: post.title.wrap,
                                content: post.content, url: post.url, images: images, version: 1)
    
    return .create { observer in
      
      AppSynClient.shared.appSyncClient?.perform(mutation: AddPostMutation(input: input), optimisticUpdate: { (transaction) in
        guard onOptimistic else { return }
        do {
          // Update our normalized local store immediately for a responsive UI
          try transaction?.update(query: AllPostsQuery()) { (data: inout AllPostsQuery.Data) in
            var item = PostItem(snapshot: post.snapshot)
            item.state = AppSynClient.ItemState.adding.val
            data.listPosts?.items?.insert(item, at: 0)
          }
        } catch let err {
          d_print(err.localizedDescription)
        }
      }) { (result, error) in
        
        defer {
          if result.isNil || result?.source == .server {
            observer.onCompleted()
          }
        }
        
        if let error = error as? AWSAppSyncClientError {
          d_print(error.localizedDescription)
          observer.onNext(.error(AppSynClient.errorHandling(error)))
          return
        }
        if let err = result?.errors?.first {
          d_print(err.errorDescription.wrap)
          observer.onNext(.error(APIError(code: 400, message: err.message)))
          return
        }
        /// Force completing the observable if no result
        guard let res = result else { return }
        observer.onNext(.next(res.data.notNil))
      }
      return Disposables.create()
    }
  }
  
  /// Subscribe to new changes from server to real-time update App data. Using generic function to support mutilple inputs, in particularly 3 types of subscription: onDelete, onAdd, onUpdate
  ///
  /// - Parameters:
  ///   - type: specified type of subscription
  ///   - regression: callback for handling output watcher
  /// - Returns: observable that wraps response of each event
  func subscribe<T: GraphQLSubscription>(for type: T, regression: ((Cancelable) -> Void)? = nil) -> Observable<(ApolloStore.ReadWriteTransaction?, PostItem)>  {
    return .create { observer in
      do {
        let watcher = try AppSynClient.shared.appSyncClient?.subscribe(subscription: type) { (result, transaction, error) in
          if let err = error { d_print(err.localizedDescription) }
          /// Handle result based on prefered type
          if let result = result {
            var snapshot: Snapshot?
            switch result.data {
            case let res as OnCreatePostSubscription.Data:
              snapshot = res.onCreatePost?.fragments.postBrief.snapshot
            case let res as OnUpdatePostSubscription.Data:
              snapshot = res.onUpdatePost?.fragments.postBrief.snapshot
            case let res as OnDeletePostSubscription.Data:
              snapshot = res.onDeletePost?.snapshot
            default: break
            }
            if let snapshot = snapshot {
              /// Emit a next event to deliver new change to listeners
              observer.onNext((transaction, PostItem(snapshot: snapshot)))
            }
          }
        }
        if let watcher = watcher as? Cancelable {
          regression?(watcher)
        }
      } catch {
        observer.onError(error)
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
}

typealias PostLocal = PostAPI
public extension PostLocal {
  
  static func updatePost(post: PostItem, transaction: ApolloStore.ReadWriteTransaction?, state: AppSynClient.ItemState = .adding, within list: inout [PostItem?]?) {
    do {
      try transaction?.update(query: AllPostsQuery(), { (data: inout AllPostsQuery.Data) in
        /// Update local data
        var crr = data.listPosts?.items
        PostLocal.updateList(post: post, list: &crr, state: state)
        data.listPosts?.items = crr
        
        /// Update current list for responsive UI update and reduce query data times
        PostLocal.updateList(post: post, list: &list, state: state)
      })
    } catch {
      d_print(error.localizedDescription)
    }
  }
  
  static func delete(transaction: ApolloStore.ReadWriteTransaction?, item: PostItem, within list: inout [PostItem?]?) {
    do {
      try transaction?.update(query: AllPostsQuery(), { (data: inout AllPostsQuery.Data) in
        
        /// Find and remove the item from local storage
        var crr = data.listPosts?.items
        PostLocal.updateList(post: item, list: &crr, state: .deleting)
        data.listPosts?.items = crr
        
        /// Directly remove item from this current list in memory for responsive UI
        PostLocal.updateList(post: item, list: &list, state: .deleting)
      })
    } catch {
      d_print(error.localizedDescription)
    }
  }
  
  static func updateStore(act: @escaping (ApolloStore.ReadWriteTransaction) -> Void) {
    _ = AppSynClient.shared.appSyncClient?.store?.withinReadWriteTransaction { (transaction) in
      act(transaction)
    }
  }
  
  private static func updateList(post: PostItem, list: inout [PostItem?]?, state: AppSynClient.ItemState) {
    switch state {
    case .deleting:
      if let idx = list?.firstIndex(where: { $0?.id == post.id }) {
        list?.remove(at: idx)
      }
    case .adding, .updating:
      if let idx = list?.firstIndex(where: { $0?.id == post.id }) {
        list?[idx] = post
      } else if state == .adding {
        list?.insert(post, at: 0)
      }
    default: break
    }
  }
}

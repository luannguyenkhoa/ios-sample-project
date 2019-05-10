//
// HomeViewModel.swift
// iOSSample
//
//

import RxSwift
import RxCocoa
import RxBlocking
import ServiceKit

final class HomeViewModel: ViewModelType {
  
  // MARK: - Input, Output
  struct Input {
    
    var fetch: Driver<Enum.FetchType>
    var willAppear: Driver<Void>
    var selectIndex: Driver<Int>
  }
  
  struct Output {
    
    var posts: Driver<[PostItem]>
    var fetching: Driver<Bool>
    var error: Driver<MessageContent?>
    var reloadItems: Driver<[Int]>
  }
  
  // MARK: - Properties
  private let navigator: HomeNavigator
  private let postUseCase: PostUseCase
  private let disposeBag = DisposeBag()
  private var token: String?
  
  /// MARK: Publishers
  private let error = PublishSubject<MessageContent?>()
  private let reloadItems = PublishSubject<[Int]>()
  
  // MARK: - Initialization and Conforms
  init(navigator: HomeNavigator, postUseCase: PostUseCase){
    self.navigator = navigator
    self.postUseCase = postUseCase
  }
  
  func transform(input: Input) -> Output {
    
    let activity = ActivityIndicator()
    let onPosts = fetchPosts(fetch: input.fetch, executing: activity)
    return Output(posts: onPosts.asDriver([]),
                  fetching: activity.asDriver(),
                  error: error.asDriver(nil),
                  reloadItems: reloadItems.asDriver([]))
  }
  
  // MARK: - Handlers
}

private typealias QuerySet = HomeViewModel
extension QuerySet {
  
  private func fetchPosts(fetch: Driver<Enum.FetchType>, executing: ActivityIndicator) -> BehaviorSubject<[PostItem]> {
    /// Using publish method to update the view once a request gets done
    let onPosts = BehaviorSubject<[PostItem]>(value: [])

    /// trigger to fetch the trips
    fetch.flatMapLatest { [unowned self] (type) -> Driver<APIResponse<(list: [PostItem], token: String?)>> in
      /// Using pagination if getting a signal
      let (limit, token) = type == .refresh ? (nil, nil) : (10, self.token)
      /// Perform request with activity indicator tracking
      return self.postUseCase.fetch(limit: limit, token: token, cachePolicy: .returnCacheDataAndFetch)
                             .trackActivity(executing).asDriver(.completed)
      }.drive(onNext: { [unowned self] res in
        switch res {
        case .next(let result):
          do {
            var lastValues = try onPosts.value()
            lastValues.removeAll(where: { item in result.list.contains(where: { $0.id == item.id }) })
            onPosts.onNext(lastValues + result.list)
          } catch { d_print(error.localizedDescription) }
          self.token = result.token
        case .error(let err): self.errorHandler |> (err, self.error)
        default: break
        }
      })
      .disposed(by: disposeBag)
    
    /// For triggering the result
    return onPosts
  }
}


extension HomeViewModel: BaseViewModel {}

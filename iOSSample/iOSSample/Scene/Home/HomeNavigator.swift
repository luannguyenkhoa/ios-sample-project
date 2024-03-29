//
// HomeNavigator.swift
// iOSSample
//
//

import ServiceKit

protocol HomeNavigator {
  
  func toPostDetail(post: PostItem)
}

struct DefaultHomeNavigator: HomeNavigator {
  
  // MARK: - Properties
  private weak var navigation: UINavigationController!
  private let postUseCase: PostUseCase
  
  // MARK: - Initialization and Conforms
  init(navigation: UINavigationController, postUseCase: PostUseCase) {
    self.navigation = navigation
    self.postUseCase = postUseCase
  }
  
  func toHome() {
    let vc = UIStoryboard(storyboard: AppStoryboard.Main).instantiate(HomeViewController.self)
    vc.viewModel = HomeViewModel(navigator: self, postUseCase: postUseCase)
    navigation.fadeRoot(vc)
  }
  
  func toPostDetail(post: PostItem) {
    
  }
}

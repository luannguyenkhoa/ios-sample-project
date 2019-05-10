import ServiceKit

protocol SignUpNavigator {
  
  func toSignIn()
  func toHome()
  func terms()
}

struct DefaultSignUpNavigator: SignUpNavigator {
  
  // MARK: - Properties
  private weak var navigation: UINavigationController!
  private let authUseCase: AuthUseCase
  
  // MARK: - Initialization and Conforms
  init(navigation: UINavigationController, authUseCase: AuthUseCase) {
    self.navigation = navigation
    self.authUseCase = authUseCase
  }
  
  func toSignUp() {
    let vc = UIStoryboard(storyboard: AppStoryboard.Auth).instantiate(SignUpViewController.self)
    vc.viewModel = SignUpViewModel(navigator: self, authUseCase: authUseCase)
    navigation.fadeRoot(vc)
  }
  
  func toSignIn() {
    DefaultSignInNavigator(navigation: navigation, authUseCase: authUseCase).toSignIn()
  }
  
  func toHome() {
    DefaultHomeNavigator(navigation: navigation, postUseCase: PostAPI()).toHome()
  }

  func terms() {
    
  }
}

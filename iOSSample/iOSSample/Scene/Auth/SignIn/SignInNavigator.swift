import ServiceKit

protocol SignInNavigator {
  
  func toSignUp()
  func toForgotPassword()
  func toHome()
}

struct DefaultSignInNavigator: SignInNavigator {
  
  // MARK: - Properties
  private weak var navigation: UINavigationController!
  private let authUseCase: AuthUseCase
  
  // MARK: - Initialization and Conforms
  init(navigation: UINavigationController, authUseCase: AuthUseCase) {
    self.navigation = navigation
    self.authUseCase = authUseCase
  }
  
  func toSignIn() {
    let vc = UIStoryboard(storyboard: AppStoryboard.Auth).instantiate(SignInViewController.self)
    vc.viewModel = SignInViewModel(navigator: self, authUseCase: authUseCase)
    navigation.fadeRoot(vc)
  }
  
  func toSignUp() {
    DefaultSignUpNavigator(navigation: navigation, authUseCase: authUseCase).toSignUp()
  }
  
  func toForgotPassword() {
    
  }
  
  func toHome() {
    DefaultHomeNavigator(navigation: navigation, postUseCase: PostAPI()).toHome()
  }
}

import ServiceKit

protocol SignInNavigator {
  
  func toSignIn()
  func toSignUp()
  func toForgotPassword()
  func toHome()
}

struct DefaultSignInNavigator: SignInNavigator {
  
  // MARK: - Properties
  private weak var navigation: UINavigationController!
  private var authUseCase: AuthUseCase!
  
  // MARK: - Initialization and Conforms
  init(navigation: UINavigationController, authUseCase: AuthUseCase) {
    self.navigation = navigation
    self.authUseCase = authUseCase
  }
  
  func toSignIn() {
    let vc = UIStoryboard(storyboard: AppStoryboard.Main).instantiate(SignInViewController.self)
    vc.viewModel = SignInViewModel(navigator: self, authUseCase: authUseCase)
    navigation.setViewControllers([vc], animated: true)
  }
  
  func toSignUp() {
    DefaultSignUpNavigator(navigation: navigation, authUseCase: authUseCase).toSignUp()
  }
  
  func toForgotPassword() {
    
  }
  
  func toHome() {
    
  }
}

import ServiceKit

protocol SignUpNavigator {
  
  func toSignIn()
  func toHome()
  func terms()
}

struct DefaultSignUpNavigator: SignUpNavigator {
  
  // MARK: - Properties
  private weak var navigation: UINavigationController!
  private var authUseCase: AuthUseCase!
  
  // MARK: - Initialization and Conforms
  init(navigation: UINavigationController, authUseCase: AuthUseCase) {
    self.navigation = navigation
    self.authUseCase = authUseCase
  }
  
  func toSignUp() {
    let vc = UIStoryboard(storyboard: AppStoryboard.Main).instantiate(SignUpViewController.self)
    vc.viewModel = SignUpViewModel(navigator: self, authUseCase: authUseCase)
    navigation.setViewControllers([vc], animated: true)
  }
  
  func toSignIn() {
    DefaultSignInNavigator(navigation: navigation, authUseCase: authUseCase).toSignIn()
  }
  
  func toHome() {
    
  }

  func terms() {
    
  }
}

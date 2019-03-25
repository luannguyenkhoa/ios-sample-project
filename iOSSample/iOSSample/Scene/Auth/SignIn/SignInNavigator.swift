import SampleKit

protocol SignInNavigator {
  
  func toSignUp()
  func toForgotPassword()
  func toHome()
}

struct DefaultSignInNavigator: SignInNavigator {
  
  // MARK: - Properties
  private weak var navigation: UINavigationController!
  
  // MARK: - Initialization and Conforms
  init(navigation: UINavigationController) {
    self.navigation = navigation
  }
  
  func toSignIn() {
    let vc = UIStoryboard(storyboard: AppStoryboard.Main).instantiate(SignInViewController.self)
    vc.viewModel = SignInViewModel(navigator: self, api: Application.shared.sampleAPI)
    navigation.setViewControllers([vc], animated: true)
  }
  
  func toSignUp() {
    DefaultSignUpNavigator(navigation: navigation).toSignUp()
  }
  
  func toForgotPassword() {
    
  }
  
  func toHome() {
    
  }
}

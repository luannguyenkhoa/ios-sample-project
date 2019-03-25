import SampleKit

protocol SignUpNavigator {
  
  func toSignIn()
  func toHome()
  func terms()
}

struct DefaultSignUpNavigator: SignUpNavigator {
  
  // MARK: - Properties
  private weak var navigation: UINavigationController!
  
  // MARK: - Initialization and Conforms
  init(navigation: UINavigationController) {
    self.navigation = navigation
  }
  
  func toSignUp() {
    let vc = UIStoryboard(storyboard: AppStoryboard.Main).instantiate(SignUpViewController.self)
    vc.viewModel = SignUpViewModel(navigator: self, api: Application.shared.sampleAPI)
    navigation.setViewControllers([vc], animated: true)
  }
  
  func toSignIn() {
    DefaultSignInNavigator(navigation: navigation).toSignIn()
  }
  
  func toHome() {
    
  }

  func terms() {
    
  }
}

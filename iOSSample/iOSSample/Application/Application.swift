import RxSwift
import SampleKit

struct Application {
  
  // MARK: - Singleton pattern
  static var shared = Application()
  lazy var sampleAPI: SampleAPI = {
    return NetworkProvider.makeSampleAPI(baseURL: Configs.apiURL.value)
  }()
  
  func configMainInterface(window: UIWindow?) {
    
    /// Determine the root view when the app gets launched based on user's logged-in state
    // Rolling into Welcome page if it's the first time
    if !(UDKey.User.confirmed.value ?? false) {
      /// TODO: To Landing page
      return
    }
    
    if UDKey<String>.User.email.value.isNil {
      let navigation = UINavigationController()
      DefaultSignInNavigator(navigation: navigation).toSignIn()
      switchRoot(vc: navigation, window: window)
      return
    }
  }
  
  private func switchRoot(vc: UIViewController, window: UIWindow?) {
    /// Make it as a root vc
    window?.rootViewController = vc
    window?.makeKeyAndVisible()
  }
}

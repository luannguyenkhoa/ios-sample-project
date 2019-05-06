import RxSwift
import ServiceKit

struct Application {
  
  // MARK: - Singleton pattern
  static var shared = Application()
  lazy var sampleAPI: SampleAPI = {
    return APIProvider.makeSampleAPI(baseURL: Configs.apiURL.value)
  }()
  
  func configMainInterface(window: UIWindow?) {
    
    /// Determine the root view when the app gets launched based on user's logged-in state
    // Rolling into Welcome page if it's the first time
    if !(SecureKey.User.confirmed.value ?? false) {
      /// TODO: To Landing page
      switchRoot(vc: UIStoryboard(storyboard: AppStoryboard.Main).instantiateInitialViewController()!, window: window)
      return
    }
    
    if SecureKey<String>.User.email.value.isNil {
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

import ServiceKit
import RxCocoa

// MARK: - Naming extensions
private typealias PrivateHandlers = SignInViewController

final class SignInViewController: BaseViewController {
  
  // MARK: - IBOutlets
  @IBOutlet private(set) weak var pressButton: UIButton!
  @IBOutlet private(set) weak var forgotButton: UIButton!
  @IBOutlet private(set) weak var signUpButton: UIButton!
  
  @IBOutlet private(set) weak var emailTextField: UITextField!
  @IBOutlet private(set) weak var pwdTextField: UITextField!
  
  // MARK: - Properties
  var viewModel: SignInViewModel!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    setup()
    binding()
  }
  
  // MARK: - Setup and Binding
  private func setup() {
    /// Dismiss keyboard when tapping on screen
    view.addGestureRecognizer(tapGesture)
  }
  
  private func binding() {
    precondition(viewModel.notNil, "ViewModel should not be nil for any reason")
    
    /// UI Controls
    rx.methodInvoked(#selector(viewWillDisappear(_:))).asDriver([]).drive(onNext: { [weak self] (_) in
      self?.view.endEditing(true)
    }).disposed(by: disposeBag)
    
    /// Start binding
    let input = SignInViewModel.Input(email: emailTextField.driver(), pwd: pwdTextField.driver(),
                                      press: pressButton.driver(), forgot: forgotButton.driver(), signup: signUpButton.driver())
    let output = viewModel.transform(input: input)
    
    /// Bind reponses
    output.error.ignoreNil().drive(onNext: {[unowned self] msg in self.errorPopup |> msg}).disposed(by: disposeBag)
  }
}

extension PrivateHandlers {
  
  // MARK: - Private handlers wrapper
}

import ServiceKit

// MARK: - Naming extensions
private typealias PrivateHandlers = SignUpViewController

final class SignUpViewController: BaseViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet private(set) weak var signInButton: UIButton!
  @IBOutlet private(set) weak var signUpButton: UIButton!
  @IBOutlet private(set) weak var termsButton: UIButton!
  
  // MARK: - Properties
  var viewModel: SignUpViewModel!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    setUp()
    binding()
  }
  
  // MARK: - Setup and Binding
  private func setUp() {
    
    self.emailTextField.becomeFirstResponder()
  }
  
  private func binding() {
    
    /// Make viewmodel transform
    let input = SignUpViewModel.Input(email: emailTextField.driveText(),
                                      signin: signInButton.driver(),
                                      terms: termsButton.driver(),
                                      press: signUpButton.driver())
    let output = viewModel.transform(input: input)
    
    /// Start binding
    output.error.ignoreNil().drive(onNext: { [unowned self] (content) in self.errorPopup |> content })
      .disposed(by: disposeBag)
    output.valid.drive(signUpButton.rx.isEnabled).disposed(by: disposeBag)
  }

}

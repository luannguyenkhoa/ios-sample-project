import RxSwift
import RxCocoa
import ServiceKit

struct SignUpViewModel: ViewModelType {
  
  // MARK: - Input, Output
  struct Input {
    
    let email: Driver<String>
    
    let signin: Driver<()>
    let terms: Driver<()>
    let press: Driver<()>
  }
  
  struct Output {
    
    let executing: Driver<Bool>
    let error: Driver<MessageContent?>
    let valid: Driver<Bool>
  }
  
  // MARK: - Properties
  private let navigator: SignUpNavigator
  private let disposeBag = DisposeBag()
  private let authUseCase: AuthUseCase
  private let error = PublishSubject<MessageContent?>()
  
  // MARK: - Initialization and Conforms
  init(navigator: SignUpNavigator, authUseCase: AuthUseCase){
    self.navigator = navigator
    self.authUseCase = authUseCase
  }
  
  func transform(input: Input) -> Output {
    
    /// Indicators
    let activityIndicator = ActivityIndicator()
    
    /// Initializers
    let valid = input.email.map({ Validation.email($0) })
    
    signUp(press: input.press, form: input.email, activity: activityIndicator, valid: valid).asDriver(())
      .drive(onNext: navigator.toHome).disposed(by: disposeBag)
    
    input.signin.drive(onNext: navigator.toSignIn).disposed(by: disposeBag)
    input.terms.drive(onNext: navigator.terms).disposed(by: disposeBag)
    
    return Output(executing: activityIndicator.asDriver(), error: error.asDriver(nil), valid: valid)
  }
  
  // MARK: - Handlers
  private func signUp(press: Driver<()>, form: Driver<(String)>, activity: ActivityIndicator, valid: Driver<Bool>) -> PublishSubject<()> {
    let complete = PublishSubject<()>()
    press.withLatestFrom(valid).filter({ $0 }).withLatestFrom(form).flatMapLatest { (arg)  in
      return self.authUseCase.signUp(email: arg, pwd: arg + "\(Date().timeStampUTC())", firstName: "", lastName: "").trackActivity(activity).asDriver(.error(nil))
      }.drive(onNext: { response in
        switch response {
        case .error(let err): self.handleError(error: err)
        case .next(let user):
          d_print(user)
          /// Mark the user have joined
          SecureKey.User.confirmed.set(true)
          
          /// Emit a next signal
          complete.onNext(())
        case .completed: break
        }
      }).disposed(by: disposeBag)
    
    return complete
  }
  
  private func handleError(error: APIError?) {
    self.error.onNext((error?.title ?? Title.Error.network.desc, error?.message ?? Message.Error.network.desc))
  }
}

extension SignUpViewModel: BaseViewModel {}

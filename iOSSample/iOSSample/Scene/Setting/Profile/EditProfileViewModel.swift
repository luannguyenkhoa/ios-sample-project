//
// EditProfileViewModel.swift
// iOSSample
//
// Copyright © 2019 Agility. All rights reserved.
//

import RxSwift
import RxCocoa
import ServiceKit

struct EditProfileViewModel: ViewModelType {
  
  typealias Text = BehaviorRelay<String?>
  // MARK: - Input, Output
  struct Input {
    
    let cancel: Driver<Void>
    let save: Driver<Void>
    let changeAvatar: Driver<Void>
  }
  
  struct Output {
    
    let ioput: InOut
    let username: String
    
    let valid: Driver<Bool>
    let avatar: Driver<UIImage?>
    let executing: Driver<Bool>
  }
  
  /// Sometimes we need a two-way binding between viewmodel and viewcontroller, inout concept comes to the rescue
  struct InOut {
    
    let firstName: Text
    let lastName: Text
    let facebook: Text
    let instagram: Text
  }
  
  // MARK: - Properties
  private let navigator: EditProfileNavigator
  private let authUseCase: AuthUseCase
  private let disposeBag = DisposeBag()
  
  // MARK: - Initialization and Conforms
  init(navigator: EditProfileNavigator, useCase: AuthUseCase){
    self.navigator = navigator
    self.authUseCase = useCase
  }
  
  func transform(input: Input) -> Output {
    
    let ioput = initialInOut()
    let avatar = BehaviorRelay<UIImage?>(value: nil)
    let activity = ActivityIndicator()
    
    /// TODO: Continue binding and logic handling
    
    return Output(ioput: ioput,
                  username: Account.singleton.user?.username ?? "",
                  valid: changeDetermine |> (ioput, avatar.asDriver()),
                  avatar: avatar.asDriver(),
                  executing: activity.asDriver())
  }
  
  // MARK: - Handlers
  private func initialInOut() -> InOut {
    let user = Account.singleton.user
    return InOut(firstName: Text(value: user?.firstName), lastName: Text(value: user?.lastName),
                 facebook: Text(value: user?.facebook), instagram: Text(value: user?.instagram))
  }
  
  private func changeDetermine(from ioput: InOut, and avatar: Driver<UIImage?>) -> Driver<Bool> {
    let user = Account.singleton.user
    let fNameChanged = ioput.firstName.asDriver().ignoreNil().distinctUntilChanged().map{ $0 != user?.firstName }
    let lNameChanged = ioput.firstName.asDriver().ignoreNil().distinctUntilChanged().map{ $0 != user?.lastName }
    let fbChanged = ioput.firstName.asDriver().ignoreNil().distinctUntilChanged().map{ $0 != user?.facebook }
    let insChanged = ioput.firstName.asDriver().ignoreNil().distinctUntilChanged().map{ $0 != user?.instagram }
    let avatarChanged = avatar.ignoreNil().distinctUntilChanged().map{_ in true }
    return Driver.combineLatest(fNameChanged, lNameChanged, fbChanged, insChanged, avatarChanged) { $0 || $1 || $2 || $3 || $4 }
  }
}

extension EditProfileViewModel: BaseViewModel {}

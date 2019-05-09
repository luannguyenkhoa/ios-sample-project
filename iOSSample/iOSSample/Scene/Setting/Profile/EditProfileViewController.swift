//
// EditProfileViewController.swift
// iOSSample
//
// Copyright © 2019 Agility. All rights reserved.
//

import RxSwift
import RxCocoa
import ServiceKit

// MARK: - Naming extensions
private typealias PrivateHandlers = EditProfileViewController

final class EditProfileViewController: BaseViewController {
  
  // MARK: - IBOutlets
  @IBOutlet private(set) weak var firstNameTextField: LimitedTextField!
  @IBOutlet private(set) weak var instagramTextField: LimitedTextField!
  @IBOutlet private(set) weak var lastNameTextField: LimitedTextField!
  @IBOutlet private(set) weak var facebookTextField: LimitedTextField!
  
  // MARK: - Properties
  var viewModel: EditProfileViewModel!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    setup()
    binding()
  }
  
  // MARK: - Setup and Binding
  private func setup() {
    
  }
  
  private func binding() {
    /// Make sure viewmode property would not always being nil
    precondition(viewModel.notNil)
    
    let input = EditProfileViewModel.Input(cancel: .empty(), save: .empty(), changeAvatar: .empty())
    let output = viewModel.transform(input: input)
    /// Two-ways binding
    (firstNameTextField.rx.text <-> output.ioput.firstName).disposed(by: disposeBag)
    (lastNameTextField.rx.text <-> output.ioput.lastName).disposed(by: disposeBag)
    (facebookTextField.rx.text <-> output.ioput.facebook).disposed(by: disposeBag)
    (instagramTextField.rx.text <-> output.ioput.instagram).disposed(by: disposeBag)
  }
  
  // MARK: - Public handlers
  
  // MARK: - IBActions
  
}

extension PrivateHandlers {
  
  // MARK: - Private handlers wrapper
}

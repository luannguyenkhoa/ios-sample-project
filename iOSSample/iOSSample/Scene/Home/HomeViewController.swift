//
// HomeViewController.swift
// iOSSample
//
// Copyright © 2019 Agility. All rights reserved.
//

import RxSwift
import RxCocoa

// MARK: - Naming extensions
private typealias PrivateHandlers = HomeViewController

final class HomeViewController: BaseViewController {
  
  // MARK: - IBOutlets
  
  
  // MARK: - Properties
  var viewModel: HomeViewModel!
  
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
    
  }
  
  // MARK: - Public handlers
  
  
  // MARK: - IBActions
  
}

extension PrivateHandlers {
  
  // MARK: - Private handlers wrapper
}

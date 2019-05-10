//
// EditProfileNavigator.swift
// iOSSample
//
//

import ServiceKit

protocol EditProfileNavigator {
  
  func back()
}

struct DefaultEditProfileNavigator: EditProfileNavigator {
  
  // MARK: - Properties
  private weak var navigation: UINavigationController!
  private let useCase: AuthUseCase
  
  // MARK: - Initialization and Conforms
  init(navigation: UINavigationController, useCase: AuthUseCase) {
    self.navigation = navigation
    self.useCase = useCase
  }
  
  func back() {
    navigation.popViewController(animated: true)
  }
}

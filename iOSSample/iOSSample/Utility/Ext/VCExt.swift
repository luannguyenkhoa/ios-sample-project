import UIKit

extension UIViewController {
  
  func presentAlert(title: String? = nil, message: String, buttons: (perform: String, cancel: String?), handler: ((UIAlertAction) -> Void)? = nil) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    /// Add primary action
    let priAct = UIAlertAction(title: buttons.perform, style: .default, handler: handler)
    alert.addAction(priAct)
    /// Add cancel button if needed
    if let cancel = buttons.cancel {
      let secAct = UIAlertAction(title: cancel, style: .cancel, handler: nil)
      alert.addAction(secAct)
    }
    present(alert, animated: true)
  }
}

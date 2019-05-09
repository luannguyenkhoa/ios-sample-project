//
//  LimitedTextField.swift
//

import ServiceKit

@IBDesignable
public class LimitedTextField: UITextField {

  @IBInspectable var maxLength: Int = 256
  public override func awakeFromNib() {
    super.awakeFromNib()
    self.addTarget(self, action: #selector(LimitedTextField.textDidChange(textField:)), for: .editingChanged)
  }

  @objc func textDidChange(textField: UITextField) {
    guard let prospectiveText = self.text, prospectiveText.count > maxLength else {
        return
    }
    let selection = selectedTextRange
    text = prospectiveText.sub(to: maxLength)
    selectedTextRange = selection
  }
}

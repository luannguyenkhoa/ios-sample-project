import UIKit

@IBDesignable public class GradientView: UIView {
  @IBInspectable public var topColor: UIColor? {
    didSet {
      configureView()
    }
  }
  @IBInspectable public var bottomColor: UIColor? {
    didSet {
      configureView()
    }
  }
  
  public override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureView()
  }
  
  required override public init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
  }
  
  public override func tintColorDidChange() {
    super.tintColorDidChange()
    configureView()
  }
  
  func configureView() {
    guard let layer = self.layer as? CAGradientLayer else { return }
    let locations = [ NSNumber(value: 0.0), NSNumber(value: 1.0) ]
    layer.locations = locations
    let color1 = topColor ?? self.tintColor as UIColor
    let color2 = bottomColor ?? UIColor.black as UIColor
    let colors = [ color1.cgColor, color2.cgColor ]
    layer.colors = colors
  }
}

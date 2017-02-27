import UIKit

/// A cell that can be used as an iOS 7 style text button, with configurable text alignment.
public class ButtonCell: UITableViewCell {

  public var buttonTextAlignment: NSTextAlignment = .left {
    didSet(newValue) {
      textLabel?.textAlignment = newValue
    }
  }

  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    guard let superview = superview else { return }
    textLabel?.textColor = superview.tintColor
  }
}

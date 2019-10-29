import UIKit

/// A cell that can be used as an iOS 7 style text button, with configurable text alignment.
public class ButtonCell: UITableViewCell {

  private var didSetTintColor = false

  public var buttonTextAlignment: NSTextAlignment = .left {
    didSet(newValue) {
      textLabel?.textAlignment = newValue
    }
  }

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    // This is an hack due to the fact that the superview tintColor changes during
    // selection/highlight but because that is an animated change this methog somehow doesn't get
    // called at completion, so we are stuck with the label being grey after selection.
    //
    // The current solution for this issue then is to pick the superview tint color only once, and
    // avoid resetting it.
    guard didSetTintColor == false else { return }

    guard let superview = superview else { return }
    didSetTintColor = true
    textLabel?.textColor = superview.tintColor
  }
}

import UIKit

/// A cell with a `UISwitch` to the right.
public class SwitchCell: UITableViewCell {

  internal let theSwitch = UISwitch()

  internal var didChange: ((UISwitch) -> ())? = .none

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    addSwitch()
    theSwitch.addTarget(self, action: #selector(switchDidChange(sender:)), for: .valueChanged)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func addSwitch() {
    theSwitch.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(theSwitch)

    addConstraints(
      [
        NSLayoutConstraint(
          item: theSwitch,
          attribute: .centerY,
          relatedBy: .equal,
          toItem: contentView,
          attribute: .centerY,
          multiplier: 1,
          constant: 0
        ),
        NSLayoutConstraint(
          item: theSwitch,
          attribute: .trailingMargin,
          relatedBy: .equal,
          toItem: contentView,
          attribute: .trailingMargin,
          multiplier: 1,
          constant: 0
        ),
        ]
    )
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    guard let superview = superview else { return }
    theSwitch.onTintColor = superview.tintColor
  }

  @objc private func switchDidChange(sender: UISwitch) {
    didChange?(sender)
  }
}

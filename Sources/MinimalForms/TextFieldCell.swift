import UIKit

/// A cell with a fullsized `UITextField`.
public class TextFieldCell: UITableViewCell {

  public let textField = UITextField()

  public var didChange: ((UITextField) -> ())? = .none

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    addTextField()
    textLabel?.text = " "
    // I was previously using .valueChanged and I could swear it worked, but that doesn't seem to
    // be the case anymore.
    textField.addTarget(self, action: #selector(selfDidChange), for: .editingDidEnd)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func addTextField() {
    textField.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(textField)

    let attributes: [NSLayoutConstraint.Attribute] = [
      .topMargin,
      .trailingMargin,
      .bottomMargin
    ]
    attributes.forEach { attribute in
      contentView.addConstraint(
        NSLayoutConstraint(
          item: textField,
          attribute: attribute,
          relatedBy: .equal,
          toItem: contentView,
          attribute: attribute,
          multiplier: 1,
          constant: 0
        )
      )
    }
    contentView.addConstraint(
      NSLayoutConstraint(
        item: textField,
        attribute: .leadingMargin,
        relatedBy: .equal,
        toItem: textLabel,
        attribute: .leadingMargin,
        multiplier: 1,
        constant: 0
      )
    )
  }

  @objc private func selfDidChange() {
    didChange?(self.textField)
  }
}

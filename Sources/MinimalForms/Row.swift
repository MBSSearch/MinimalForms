import UIKit

/// The availalbe kind of rows.
public enum Row {

  case detail(
    text: String,
    detail: String,
    accessoryType: UITableViewCellAccessoryType,
    afterConfigure: ((DetailCell) -> ())?,
    didSelect: (() -> ())?
  )

  case `switch`(
    text: String,
    detail: String?,
    isOn: Bool,
    didChange: ((UISwitch) -> ()),
    afterConfigure: ((SwitchCell) -> ())?,
    didSelect: (() -> ())?
  )

  case button(
    title: String,
    alignment: NSTextAlignment,
    didSelect: (() -> ())?,
    afterConfigure: ((ButtonCell) -> ())?
  )

  case textField(
    placeholder: String?,
    value: String?,
    didChange: ((UITextField) -> ()),
    afterConfigure: ((TextFieldCell) -> ())?,
    didSelect: (() -> ())?
  )
}

extension Row {

  public var identifier: String {
    switch self {
    case .detail: return "detail"
    case .switch: return "switch"
    case .button: return "button"
    case .textField: return "textfiel"
    }
  }

  public var cellClass: UITableViewCell.Type {
    switch self {
    case .detail: return DetailCell.self
    case .switch: return SwitchCell.self
    case .button: return ButtonCell.self
    case .textField: return TextFieldCell.self
    }
  }

  public var didSelect: (() -> ())? {
    switch self {
    case .button(_, _, let _didSelect, _): return _didSelect
    case .detail(_, _, _, _, let _didSelect): return _didSelect
    case .switch(_, _, _, _, _, let _didSelect): return _didSelect
    case .textField(_, _, _, _, let _didSelect): return _didSelect
    }
  }

  public func configure(_ cell: UITableViewCell) {
    switch self {

    case .detail(let text, let detail, let accessoryType, let afterConfigure, _):
      guard let _cell = cell as? DetailCell else { return }
      _cell.textLabel?.text = text
      _cell.detailTextLabel?.text = detail
      _cell.accessoryType = accessoryType
      afterConfigure?(_cell)

    case .switch(let text, let detail, let isOn, let didChange, let afterConfigure, _):
      guard let _cell = cell as? SwitchCell else { return }
      _cell.textLabel?.text = text
      _cell.detailTextLabel?.text = detail
      _cell.theSwitch.isOn = isOn
      _cell.didChange = didChange
      afterConfigure?(_cell)

    case .button(let title, let alignment, _, let afterConfigure):
      guard let _cell = cell as? ButtonCell else { return }
      _cell.textLabel?.text = title
      _cell.textLabel?.textAlignment = alignment
      afterConfigure?(_cell)

    case .textField(let placeholder, let value, let didChange, let afterConfigure, _):
      guard let _cell = cell as? TextFieldCell else { return }
      _cell.textField.placeholder = placeholder
      _cell.textField.text = value
      _cell.didChange = didChange
      afterConfigure?(_cell)
    }
  }
}

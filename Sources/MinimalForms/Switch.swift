import UIKit

public struct Switch {
  let text: String
  let detail: String?
  let isOn: Bool
  let didChange: ((UISwitch) -> ())
  let afterConfigure: ((SwitchCell) -> ())?
  let didSelect: (() -> ())?

  public init(
    text: String,
    detail: String? = .none,
    isOn: Bool = false,
    didChange: @escaping ((UISwitch) -> ()),
    afterConfigure: ((SwitchCell) -> ())? = .none,
    didSelect: (() -> ())? = .none
    ) {
    self.text = text
    self.detail = detail
    self.isOn = isOn
    self.didChange = didChange
    self.afterConfigure = afterConfigure
    self.didSelect = didSelect
  }
}

extension Switch: RowConvertible {
  public func toRow() -> Row {
    return Row.switch(
      text: text,
      detail: detail,
      isOn: isOn,
      didChange: didChange,
      afterConfigure: afterConfigure,
      didSelect: didSelect
    )
  }
}

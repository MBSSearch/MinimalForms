import UIKit

public struct Switch {
  let text: String
  let detail: String?
  let didChange: ((UISwitch) -> ())
  let afterConfigure: ((SwitchCell) -> ())?
  let didSelect: (() -> ())?

  public init(
    text: String,
    detail: String? = .none,
    didChange: @escaping ((UISwitch) -> ()),
    afterConfigure: ((SwitchCell) -> ())? = .none,
    didSelect: (() -> ())? = .none
    ) {
    self.text = text
    self.detail = detail
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
      didChange: didChange,
      afterConfigure: afterConfigure,
      didSelect: didSelect
    )
  }
}

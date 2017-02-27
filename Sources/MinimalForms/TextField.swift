import UIKit

public class TextField: NSObject {
  let placeholder: String
  let value: String?
  let didChange: (UITextField) -> ()
  let afterConfigure: ((TextFieldCell) -> ())?
  let didSelect: (() -> ())?

  public init(
    placeholder: String,
    didChange: @escaping (UITextField) -> (),
    value: String? = .none,
    afterConfigure: ((TextFieldCell) -> ())? = .none,
    didSelect: (() -> ())? = .none
    ) {
    self.placeholder = placeholder
    self.value = value
    self.didChange = didChange
    self.afterConfigure = afterConfigure
    self.didSelect = didSelect
  }
}

extension TextField: RowConvertible {
  public func toRow() -> Row {
    return Row.textField(
      placeholder: placeholder,
      value: value,
      didChange: didChange,
      afterConfigure: afterConfigure,
      didSelect: didSelect
    )
  }
}

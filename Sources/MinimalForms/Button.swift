import UIKit

public struct Button {
  let title: String
  let alignment: NSTextAlignment
  let didSelect: (() -> ())?
  let afterConfigure: ((ButtonCell) -> ())?

  public init(
    title: String,
    alignment: NSTextAlignment = .center,
    didSelect: (() -> ())? = .none,
    afterConfigure: ((ButtonCell) -> ())? = .none
    ) {
    self.title = title
    self.alignment = alignment
    self.didSelect = didSelect
    self.afterConfigure = afterConfigure
  }
}

extension Button: RowConvertible {
  public func toRow() -> Row {
    return Row.button(
      title: title,
      alignment: alignment,
      didSelect: didSelect,
      afterConfigure: afterConfigure
    )
  }
}

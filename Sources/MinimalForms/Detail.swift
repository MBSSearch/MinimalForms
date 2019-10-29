import UIKit

public struct Detail {
  let text: String
  let detail: String
  let accessoryType: UITableViewCell.AccessoryType
  let afterConfigure: ((DetailCell) -> ())?
  let didSelect: (() -> ())?

  public init(
    text: String,
    detail: String,
    accessoryType: UITableViewCell.AccessoryType = .none,
    afterConfigure: ((DetailCell) -> ())? = .none,
    didSelect: (() -> ())? = .none
    ) {
    self.text = text
    self.detail = detail
    self.accessoryType = accessoryType
    self.afterConfigure = afterConfigure
    self.didSelect = didSelect
  }
}

extension Detail: RowConvertible {
  public func toRow() -> Row {
    return Row.detail(
      text: text,
      detail: detail,
      accessoryType: accessoryType,
      afterConfigure: afterConfigure,
      didSelect: didSelect
    )
  }
}

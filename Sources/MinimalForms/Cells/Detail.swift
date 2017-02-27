public struct Detail {
  let text: String
  let detail: String
  let afterConfigure: ((DetailCell) -> ())?
  let didSelect: (() -> ())?

  public init(
    text: String,
    detail: String,
    afterConfigure: ((DetailCell) -> ())? = .none,
    didSelect: (() -> ())? = .none
    ) {
    self.text = text
    self.detail = detail
    self.afterConfigure = afterConfigure
    self.didSelect = didSelect
  }
}

extension Detail: RowConvertible {
  public func toRow() -> Row {
    return Row.detail(
      text: text,
      detail: detail,
      afterConfigure: afterConfigure,
      didSelect: didSelect
    )
  }
}

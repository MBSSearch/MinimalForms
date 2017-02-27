/// A struct representing the a table view section.
public struct Section {
  public let title: String
  public let rows: [Row]

  public init(title: String, rows: [Row]) {
    self.title = title
    self.rows = rows
  }
}

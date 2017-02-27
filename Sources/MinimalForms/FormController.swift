import UIKit

public class FormController: NSObject, UITableViewDataSource, UITableViewDelegate {
  let sections: [Section]

  public init(sections: [Section], tableView: UITableView) {
    self.sections = sections
    super.init()

    configure(tableView)
  }

  private func configure(_ tableView: UITableView) {
    tableView.dataSource = self
    tableView.delegate = self

    sections
      .map { section in section.rows }
      .joined()
      .toArray()
      .forEach { row in
        tableView.register(row.cellClass, forCellReuseIdentifier: row.identifier)
    }
  }

  public func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].rows.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let config = sections[indexPath.section].rows[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: config.identifier, for: indexPath)
    config.configure(cell)
    return cell
  }

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let config = sections[indexPath.section].rows[indexPath.row]

    config.didSelect?()
  }
}

extension FlattenBidirectionalCollection {

  func toArray() -> Array<Base.Iterator.Element.Iterator.Element> {
    return Array(self)
  }
}

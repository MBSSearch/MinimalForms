import UIKit

public class FormController: NSObject, UITableViewDataSource, UITableViewDelegate {

  let sections: [Section]

  let keyboardController: FormKeyboardController

  public init(sections: [Section], tableView: UITableView) {
    self.sections = sections
    self.keyboardController = FormKeyboardController(formTableView: tableView)
    super.init()

    configure(tableView)
  }

  /// Call this from the view controller in which the form is contained `viewDidAppear(_:)`
  /// method in order to notify the `FormController` instance that is time to perform those
  /// internal operations that depend on ththatis view lifecycle event.
  ///
  /// - Note: Currently this is used only to ensure the keyboard handling is registered. You can
  ///         omit if your form doesn't have text inputs.
  public func ownerViewDidAppear() {
    keyboardController.subscribeToKeyboardDisplayNotifications()
  }

  /// Call this from the view controller in which the form is contained `viewWillDisappear(_:)`
  /// method in order to notify the `FormController` instance that is time to perform those
  /// internal operations that depend on that view lifecycle event.
  ///
  /// - Note: Currently this is used only to ensure the keyboard handling is deregistered. You can
  ///         omit if your form doesn't have text inputs.
  public func ownerViewWillDisappear() {
    keyboardController.unsubscribeFromKeybaordDispalyNotifications()
  }

  private func configure(_ tableView: UITableView) {
    tableView.dataSource = self
    tableView.delegate = self

    sections
      .flatMap { $0.rows }
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

    if let textField = (cell as? TextFieldCell)?.textField {
      textField.inputAccessoryView = keyboardController.toolbar
    }

    return cell
  }

  public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard section <= sections.count - 1 else { return .none }
    let config = sections[section]
    return config.title
  }

  public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    // With this we prevent cells that don't have a `didSelect` property from being selectable.
    return sections[indexPath.section].rows[indexPath.row].didSelect != nil
  }

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let config = sections[indexPath.section].rows[indexPath.row]

    keyboardController.resignKeyboardResponder()

    config.didSelect?()
  }
}

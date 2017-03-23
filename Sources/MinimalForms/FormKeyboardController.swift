import UIKit

class FormKeyboardController {

  private weak var tableView: UITableView?

  public lazy var toolbar: UIToolbar = {
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.tableView?.frame.size.width ?? 0, height: 50))
    toolbar.barStyle = .default
    toolbar.items = [
      UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.plain, target: self, action: #selector(previous)),
      UIBarButtonItem(title: ">", style: UIBarButtonItemStyle.plain, target: self, action: #selector(next)),
      UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(done))]
    toolbar.sizeToFit()
    return toolbar
  }()

  public init(formTableView: UITableView) {
    self.tableView = formTableView
  }

  @objc private func next() {
    guard let firstResponder = self.firstResponder() else { return }

    let textFields = orderedTextFields()

    guard let index = textFields.index(of: firstResponder) else { return }

    if index == textFields.count - 1 {
      // this was the last text field
      firstResponder.resignFirstResponder()
    } else {
      textFields[index + 1].becomeFirstResponder()
    }
  }
  @objc private func previous() {
    guard let firstResponder = self.firstResponder() else { return }

    let textFields = orderedTextFields()

    guard let index = textFields.index(of: firstResponder) else { return }

    if index > 0 {
      textFields[index - 1].becomeFirstResponder()
    }
  }
  @objc private func done() {
    guard let firstResponder = self.firstResponder() else { return }
    firstResponder.resignFirstResponder()
  }

  private func orderedTextFields() -> [UITextField] {
    guard let tableView = self.tableView else { preconditionFailure("Called \(#function) before the table view had been set") }
    return extractTextFields(from: tableView)
      .sorted(by: { tableView.convert($0.center, from: $0).y < tableView.convert($1.center, from: $1).y })
  }

  private func extractTextFields(from view: UIView) -> [UITextField] {
    if let textField = view as? UITextField {
      return [textField]
    }
    if view.subviews.count > 0 {
      return view.subviews.flatMap { extractTextFields(from: $0) }
    }
    return []
  }

  private func firstResponder() -> UITextField? {
    guard let tableView = self.tableView else { preconditionFailure("Called \(#function) before the table view had been set") }
    return extractTextFields(from: tableView).first(where: { $0.isFirstResponder })
  }
}

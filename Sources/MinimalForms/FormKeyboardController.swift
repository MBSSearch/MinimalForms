import UIKit

class FormKeyboardController {

  fileprivate weak var tableView: UITableView?

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

    subscribeToKeyboardDisplayNotifications()
  }

  deinit {
    unsubscribeFromKeybaordDispalyNotifications()
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

      scrollTableToFirstResponderCell()
    }
  }

  @objc private func previous() {
    guard let firstResponder = self.firstResponder() else { return }

    let textFields = orderedTextFields()

    guard let index = textFields.index(of: firstResponder) else { return }

    if index > 0 {
      textFields[index - 1].becomeFirstResponder()

      scrollTableToFirstResponderCell()
    }
  }

  @objc private func done() {
    guard let firstResponder = self.firstResponder() else { return }
    firstResponder.resignFirstResponder()
  }

  // MARK: -

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

  // MARK: -

  private func scrollTableToFirstResponderCell() {
    guard let firstResponder = self.firstResponder() else { return }

    guard let tableView = tableView else { return }
    let point = tableView.convert(firstResponder.center, from: firstResponder)
    guard let indexPath = tableView.indexPathForRow(at: point) else { return }
    tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
  }
}

// MARK: - Keyboard Display Handling
//
// This code is taken from https://gist.github.com/braking/5575962
extension FormKeyboardController {

  fileprivate func subscribeToKeyboardDisplayNotifications() {
    let notificationCenter = NotificationCenter.default

    notificationCenter.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: .UIKeyboardWillShow,
      object: nil
    )

    notificationCenter.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: .UIKeyboardWillHide,
      object: nil
    )
  }

  fileprivate func unsubscribeFromKeybaordDispalyNotifications() {
    NotificationCenter.default.removeObserver(self)
  }

  @objc private func keyboardWillShow(notification: NSNotification) {
    guard let size = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect)?.size else { return }
    guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

    // The original code uses the keyboard width or height as the bottom parameter depending on the
    // orientation of the device. It's not clear to me why. I've tried on iOS 10 with only ever
    // using the height and it seems to work well.
    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: size.height, right: 0)

    UIView.animate(withDuration: duration) { [weak self] in
      guard let tableView = self?.tableView else { return }

      tableView.contentInset = contentInsets
      tableView.scrollIndicatorInsets = contentInsets
    }
  }

  @objc private func keyboardWillHide(notification: NSNotification) {
    guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

    UIView.animate(withDuration: duration) { [weak self] in
      guard let tableView = self?.tableView else { return }

      tableView.contentInset = .zero
      tableView.scrollIndicatorInsets = .zero
    }
  }
}

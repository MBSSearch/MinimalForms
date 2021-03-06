import UIKit
import MinimalForms

struct Resource {
  var isOn: Bool = false
  var text: String? = .none

  func toString() -> String {
    return "Resource\nisOn = \(isOn)\ntext = \(text ?? "`.none`")"
  }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  let tableView = UITableView(frame: .zero, style: .grouped)

  var resource = Resource()

  var sections: [Section]? = .none

  var formController: FormController? = .none

  override func viewDidLoad() {
    super.viewDidLoad()

    addView(tableView, asFullSizeSubviewOf: view)

    let t: [Section] = [
      Section(
        title: "Section with Title",
        rows: [
          Detail(text: "This is not really a form component", detail: "¯\\_(ツ)_/¯").toRow(),
          Detail(text: "Type of something", detail: "type a", accessoryType: .disclosureIndicator).toRow(),
          Switch(text: "baz", didChange: { theSwitch in self.resource.isOn = theSwitch.isOn }).toRow(),
          ]
      ),
      Section(
        title: "",
        rows: [
          Button(
            title: "Push form",
            alignment: .center,
            didSelect: { [unowned self] in
              self.navigationController?.pushViewController(OtherViewController(), animated: true)
            }
          ).toRow()
          ]
        ),
        Section(
          title: "",
          rows: [
          Detail(text: "This is not really a form component", detail: "¯\\_(ツ)_/¯").toRow(),
          Detail(text: "Type of something", detail: "type a", accessoryType: .disclosureIndicator).toRow(),
          Switch(text: "baz", didChange: { theSwitch in self.resource.isOn = theSwitch.isOn }).toRow(),
          ]
      ),
      Section(
        title: "",
        rows: [
          TextField(placeholder: "bang", didChange: { textField in self.resource.text = "\(self.resource.text ?? "")\(textField.text ?? "")" }).toRow(),
          TextField(placeholder: "bong", didChange: { textField in self.resource.text = "\(self.resource.text ?? "")\(textField.text ?? "")" }).toRow(),
        ]
      ),
      Section(
        title: "",
        rows: [
          Switch(text: "baz 2", detail: "zab", isOn: true, didChange: { theSwitch in self.resource.isOn = theSwitch.isOn }).toRow(),
          TextField(placeholder: "bong 2", didChange: { textField in self.resource.text = "\(self.resource.text ?? "")\(textField.text ?? "")" }).toRow(),
          ]
      ),
      Section(
        title: "",
        rows: [
          Button(title: "bong", didSelect: { self.presentResource() }).toRow()
        ]
      ),
    ]

    formController = FormController(
      sections: t,
      tableView: tableView
    )
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    formController?.ownerViewDidAppear()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    formController?.ownerViewWillDisappear()
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return sections?.count ?? 0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections?[section].rows.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let sections = sections else { return UITableViewCell() }

    let config = sections[indexPath.section].rows[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: config.identifier, for: indexPath)
    config.configure(cell)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    guard let sections = sections else { return }

    let config = sections[indexPath.section].rows[indexPath.row]

    config.didSelect?()
  }

  func presentResource() {
    let alert = UIAlertController(title: .none, message: resource.toString(), preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: .none))
    present(alert, animated: true, completion: .none)
  }
}

// Thanks: https://spin.atomicobject.com/2015/10/13/switching-child-view-controllers-ios-auto-layout/
internal func addView(_ view: UIView, asFullSizeSubviewOf parentView: UIView) {
  view.translatesAutoresizingMaskIntoConstraints = false
  parentView.addSubview(view)

  var viewBindingsDict = [String: AnyObject]()
  viewBindingsDict["subView"] = view
  parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                           options: [], metrics: nil, views: viewBindingsDict))
  parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                           options: [], metrics: nil, views: viewBindingsDict))
}

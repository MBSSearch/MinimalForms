import UIKit
import MinimalForms

class OtherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  let tableView = UITableView(frame: .zero, style: .grouped)

  var sections: [Section]? = .none

  var formController: FormController? = .none

  override func viewDidLoad() {
    super.viewDidLoad()

    addView(tableView, asFullSizeSubviewOf: view)

    let t: [Section] = [
      Section(
        title: "",
        rows: [
          TextField(placeholder: "bang", didChange: { _ in }).toRow(),
          TextField(placeholder: "bong", didChange: { _ in }).toRow()
        ]
      )
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
}

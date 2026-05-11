//
//  DebugViewController.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

import UIKit

final class DebugViewController: UIViewController, DebugViewProtocol {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var closeButton: UIButton!

    var presenter: DebugPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter?.viewDidLoad()
    }

    func reloadData() {
        tableView.reloadData()
    }

    @IBAction private func closeTapped(_ sender: UIButton) {
        presenter?.didTapDismiss()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DebugCell")
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.1)
    }
}

// MARK: - UITableViewDataSource

extension DebugViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DebugCell", for: indexPath)
        guard let item = presenter?.items[indexPath.row] else { return cell }
        cell.textLabel?.text = item.displayName
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        switch item.value {
        case .toggle(let isOn):
            let toggle = UISwitch()
            toggle.isOn = isOn
            toggle.onTintColor = UIColor(red: 0.90, green: 0.16, blue: 0.24, alpha: 1)
            toggle.tag = indexPath.row
            toggle.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
            cell.accessoryView = toggle
        case .text(let text):
            let label = UILabel()
            label.text = text
            label.textColor = .secondaryLabel
            label.font = .systemFont(ofSize: 15)
            label.sizeToFit()
            cell.accessoryView = label
        }
        return cell
    }

    @objc private func switchToggled(_ sender: UISwitch) {
        presenter?.didToggleItem(at: sender.tag)
    }
}

// MARK: - UITableViewDelegate

extension DebugViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}

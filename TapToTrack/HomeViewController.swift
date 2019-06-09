//
//  HomeViewController.swift
//  TapToTrack
//
//  Created by Alen Liang on 2019/4/4.
//  Copyright © 2019 Alen Liang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var logButton: UIButton!

    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Account.shared.delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)

        refresh()
    }
    
    @IBAction func add(_ sender: Any) {
        performSegue(withIdentifier: "presentLogEditor", sender: Float(100))
    }

    @IBAction func log(_ sender: Any) {
        performSegue(withIdentifier: "presentLogEditor", sender: Float(-100))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentLogEditor", let vc = segue.destination as? LogEditorViewController {
            if let log = sender as? Log {
                vc.log = log
            }

            if let change = sender as? Float {
                vc.segmentedControlShouldSelectIndex = change > 0 ? 0 : 1
            }

            vc.delegate = self
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Account.shared.sortedLogs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeTableViewCell
        cell.log = Account.shared.sortedLogs[indexPath.row]
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let log = Account.shared.sortedLogs[indexPath.row]
        performSegue(withIdentifier: "presentLogEditor", sender: log)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .none:
            break

        case .delete:
            let log = Account.shared.sortedLogs[indexPath.row]
            Account.shared.delete(uuid: log.uuid)

        case .insert:
            break

        @unknown default:
            break
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
}

extension HomeViewController: AccountDelegate {
    func refresh() {
        moneyLabel.text = Account.shared.balanceText
        moneyLabel.textColor = Account.shared.balance >= 0 ? Account.positiveColor : Account.negativeColor
        tableView.reloadData()
    }
}

extension HomeViewController: LogEditorViewControllerDelegate {
    func handleSave(log: Log?, date: Date, change: Float) {
        if let log = log {
            Account.shared.edit(uuid: log.uuid, date: date, change: change)
        } else {
            Account.shared.add(date: date, change: change)
        }
    }
}

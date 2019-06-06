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

    let account = Account()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        account.delegate = self

        tableView.dataSource = self
        tableView.delegate = self

        tableView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)

        refresh()
    }
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "💰充值", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.placeholder = "请输入充值金额"
        }

        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak alert] (_) in
            guard let text = alert?.textFields?.first?.text, let change = Float(text) else {
                return
            }

            self.account.add(date: Date(), change: change)
        }))

        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func log(_ sender: Any) {
        let alert = UIAlertController(title: "👨‍⚕️消费", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.text = "100"
            textField.placeholder = "请输入消费金额"
        }

        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak alert] (_) in
            guard let text = alert?.textFields?.first?.text, let change = Float(text) else {
                return
            }

            self.account.add(date: Date(), change: -change)
        }))

        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return account.sortedLogs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeTableViewCell
        cell.log = account.sortedLogs[indexPath.row]
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .none:
            break

        case .delete:
            let log = account.sortedLogs[indexPath.row]
            account.delete(uuid: log.uuid)

        case .insert:
            break

        @unknown default:
            break
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension HomeViewController: AccountDelegate {
    func refresh() {
        moneyLabel.text = account.balanceText
        moneyLabel.textColor = account.balance >= 0 ? Account.positiveColor : Account.negativeColor
        tableView.reloadData()
    }
}

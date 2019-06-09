//
//  LogEditorViewController.swift
//  TapToTrack
//
//  Created by Alen Liang on 2019/6/6.
//  Copyright © 2019 Alen Liang. All rights reserved.
//

import UIKit

protocol LogEditorViewControllerDelegate {
    func handleSave(log: Log?, date: Date, change: Float)
}

class LogEditorViewController: UIViewController {

    var log: Log? = nil
    var segmentedControlShouldSelectIndex: Int = 0
    
    var delegate: LogEditorViewControllerDelegate? = nil

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var changeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        containerView.layer.cornerRadius = 10
        containerView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]

        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh-CN")

        if let log = log {
            datePicker.date = log.date
            segmentedControl.selectedSegmentIndex = log.change > 0 ? 0 : 1
            changeTextField.text = String(Int(abs(log.change)))
        } else {
            datePicker.date = Date()
            segmentedControl.selectedSegmentIndex = segmentedControlShouldSelectIndex
            changeTextField.text = segmentedControlShouldSelectIndex == 0 ? "" : "100"
        }

        dateChanged(self)
        segmentChanged(self)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeTextField.resignFirstResponder()
    }

    @IBAction func dateChanged(_ sender: Any) {
        dateLabel.text = HomeTableViewCell.dateFormatter.string(from: datePicker.date)
    }

    @IBAction func segmentChanged(_ sender: Any) {
        changeTextField.textColor = segmentedControl.selectedSegmentIndex == 0
            ? Account.positiveColor
            : Account.negativeColor
    }

    @IBAction func changesChanged(_ sender: Any) {
        // todo
    }

    @objc func handleKeyboardWillShow(_ obj: NSNotification) {
        guard let value = obj.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }

        UIView.animate(withDuration: 0, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: -value.cgRectValue.height)
        })
    }

    @objc func handleKeyboardWillHide(_ obj: NSNotification) {
        UIView.animate(withDuration: 0, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: Any) {
        guard let text = changeTextField.text, let change = Float(text) else {
            return
        }

        let log = self.log
        let date = datePicker.date
        let sign: Float = segmentedControl.selectedSegmentIndex == 0 ? 1 : -1

        dismiss(animated: true) {
            self.delegate?.handleSave(
                log: log,
                date: date,
                change: sign * change
            )
        }
    }
}

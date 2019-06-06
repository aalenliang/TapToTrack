//
//  HomeTableViewCell.swift
//  TapToTrack
//
//  Created by Alen Liang on 2019/4/4.
//  Copyright © 2019 Alen Liang. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    static let dateFormatter = DateFormatter()

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!

    var log: Log? = nil {
        didSet {
            guard let log = log else {
                return
            }

            dateLabel.text = HomeTableViewCell.dateFormatter.string(from: log.date)
            changeLabel.text = Account.numberFormatter.string(from: NSNumber(value: log.change))
            changeLabel.textColor = log.change >= 0 ? Account.positiveColor : Account.negativeColor
        }
    }
}

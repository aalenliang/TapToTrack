//
//  Account.swift
//  TapToTrack
//
//  Created by Alen Liang on 2019/4/4.
//  Copyright © 2019 Alen Liang. All rights reserved.
//

import UIKit

class Log: NSObject, NSCoding {
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("logs")

    struct PropertyKey {
        static let uuid = "uuid"
        static let date = "date"
        static let change = "change"
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(uuid, forKey: PropertyKey.uuid)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(change, forKey: PropertyKey.change)
    }

    required init?(coder aDecoder: NSCoder) {
        guard let uuid = aDecoder.decodeObject(forKey: PropertyKey.uuid) as? String else {
            return nil
        }

        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
            return nil
        }

        let change = aDecoder.decodeFloat(forKey: PropertyKey.change)

        guard change != 0 else {
            return nil
        }

        self.uuid = uuid
        self.date = date
        self.change = change
    }

    let uuid: String
    let date: Date
    let change: Float

    init(date: Date, change: Float) {
        self.uuid = UUID().uuidString
        self.date = date
        self.change = change
    }
}

protocol AccountDelegate {
    func refresh()
}

class Account {
    static let shared = Account()

    private init() {
        logs = NSKeyedUnarchiver.unarchiveObject(withFile: Log.ArchiveURL.path) as? [Log] ?? []
    }

    static let numberFormatter = NumberFormatter()

    class var positiveColor: UIColor {
        return UIColor(red:0.30, green:0.74, blue:0.52, alpha:1.00)
    }

    class var negativeColor: UIColor {
        return UIColor(red: 0.94, green: 0.46, blue: 0.24, alpha: 1.00)
    }

    var delegate: AccountDelegate? = nil

    private var logs: [Log] = [] {
        didSet {
            save()
            delegate?.refresh()
        }
    }
}

extension Account {
    var sortedLogs: [Log] {
        return logs.sorted { $0.date > $1.date }
    }

    var balance: Float {
        return logs.reduce(0) { (result, log) in result + log.change }
    }

    var balanceText: String? {
        return Account.numberFormatter.string(from: NSNumber(value: balance))
    }
}


extension Account {
    func add(date: Date, change: Float) {
        logs.append(Log(date: date, change: change))
    }

    func edit(uuid: String, date: Date, change: Float) {
        logs = logs.map {
            $0.uuid == uuid ? Log(date: date, change: change) : $0
        }
    }

    func delete(uuid: String) {
        logs = logs.filter { $0.uuid != uuid }
    }

    func save() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(logs, toFile: Log.ArchiveURL.path)
        if isSuccessfulSave {
            print("🎉Hooray")
        } else {
            print("😢Oops")
        }
    }
}

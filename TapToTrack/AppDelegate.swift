//
//  AppDelegate.swift
//  TapToTrack
//
//  Created by Alen Liang on 2019/4/4.
//  Copyright © 2019 Alen Liang. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.

        Account.numberFormatter.locale = Locale.current
        Account.numberFormatter.numberStyle = .currency

        HomeTableViewCell.dateFormatter.locale = Locale.current
        HomeTableViewCell.dateFormatter.dateFormat = "yyyy-MM-dd"

        return true
    }
}


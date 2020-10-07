//
//  AppDelegate.swift
//  Dream App
//
//  Created by Samantha Gatt on 3/24/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge,.sound]) { (sucess, error) in
            if sucess {
                // schedule test
            } else if let _ = error {
                print("error occured")
            }
        }
        
        return true
    }
    
    
}


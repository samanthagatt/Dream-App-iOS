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
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UITextField.appearance().keyboardAppearance = UIKeyboardAppearance.dark
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge,.sound]) { (sucess, error) in
            if sucess {
                // schedule test
            } else if let _ = error {
                print("error occured")
            }
        }
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       
            DispatchQueue.main.async {
                guard let window = UIApplication.shared.keyWindow else { return }

                let myTabBar = window.rootViewController as! UITabBarController // Getting Tab Bar
                   myTabBar.selectedIndex = 1 //Selecting tab here
                   
            }
            // TODO: implement your logic
            // just don't forget to dispatch UI stuff on main thread
        
    }

    
    
}


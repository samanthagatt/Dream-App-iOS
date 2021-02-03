//
//  AppDelegate.swift
//  Dream App
//
//  Created by Samantha Gatt on 3/24/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var docRef : DocumentReference!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        docRef = Firestore.firestore().document("DreamStudio/Dictionary")
        
        docRef.getDocument { (documentSnapShot, error) in
            guard let docuSnapshot = documentSnapShot, documentSnapShot?.exists ?? false else { return }
            let dictionaryData = docuSnapshot.data()
            print(dictionaryData)
        }
        
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
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.filter({
                $0.isKeyWindow
            }).first else { return }
            
            let myTabBar = window.rootViewController as! UITabBarController // Getting Tab Bar
            myTabBar.selectedIndex = 1 //Selecting tab here
            
        }
    }
}

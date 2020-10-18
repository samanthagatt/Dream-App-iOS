//
//  NotificationManager.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/6/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmNotofications {
    static let shared = AlarmNotofications()
    
    func sendNotification(with date: Date, id: String){
        let content = UNMutableNotificationContent()
        content.title = "RECORD YOUR DREAM!"
        content.sound  = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm.mp3"))
        content.body = "You set an alarm to record your dream. If you don't record, you have a 90% chance of forgetting."
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date), repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("Something went wrong with sending out notoficaation for alarm \(id)")
            }
        }
    }
    
    func removeNotification(with id: String){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            for request in requests {
                if request.identifier == id {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
                }
            }
        }
    }
    
}

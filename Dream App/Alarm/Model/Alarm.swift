//
//  Alarm.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/6/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

//struct Alarm : Codable, Equatable {
//    let date : Date
//    var isOn : Bool = true
//    let identifier : String
//}

class Alarm : Codable, Equatable {
    let date : Date
    var isOn : Bool
    let identifier : String
    
    init(date: Date, identifier: String, isOn : Bool = true) {
        self.date = date
        self.identifier = identifier
        self.isOn = isOn
      }
    
    static func ==(lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.date == rhs.date && lhs.isOn == rhs.isOn && lhs.identifier == rhs.identifier
    }

}



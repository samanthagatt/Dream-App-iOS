//
//  Alarm.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/6/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

struct Alarm : Codable, Equatable {
    let date : Date
    var isOn : Bool = true
    let identifier : String
}



//
//  Dream.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/7/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

struct Dream: Codable, Equatable {
    var title: String
    var description: String
    var date: Date
    var identifier: String
    var recordingName: String?
}

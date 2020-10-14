//
//  Dream.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/7/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

class Dream : Codable, Equatable {
    var title : String
    var description : String
    var date : Date
    var identifier : String
    var recordingURL : URL?
    
    init(title : String, description : String, date: Date, identifier : String, recordingURL : URL?) {
        self.title = title
        self.description = description
        self.date = date
        self.identifier = identifier
        self.recordingURL = recordingURL
    }
    
    static func ==(lhs: Dream, rhs: Dream) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description && lhs.date == rhs.date && lhs.identifier == rhs.identifier && lhs.recordingURL == rhs.recordingURL
       }
}

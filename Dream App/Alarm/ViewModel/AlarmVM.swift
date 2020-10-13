//
//  AlarmVM.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/7/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

class AlarmViewModel {
    static let shared = AlarmViewModel()
    
    var savedAlarms : [String : Alarm] = [:]
    
    var alarmArray : [Alarm] {
    return Array(savedAlarms.values).sorted { $0.date > $1.date }
    }
    
    func saveAlarm(alarm: Alarm){
        savedAlarms[alarm.identifier] = alarm
        saveToPersistence()
    }
    
    func deleteAlarm(alarm : Alarm){
        savedAlarms.removeValue(forKey: alarm.identifier)
        saveToPersistence()
    }
    
    func updateAlarm(alarm : Alarm){
        guard let oldAlarm = savedAlarms[alarm.identifier] else { return }
        oldAlarm.isOn.toggle()
        saveToPersistence()
    }
    
    // URL to the bank
    var savedAlarmURL : URL?{
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileName = "Alarm(Persistence).plist"
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    func saveToPersistence(){
        let plistEncoder = PropertyListEncoder()
        do {
            guard let savedResultsURL = savedAlarmURL else { return }
            let resultsData = try plistEncoder.encode(savedAlarms)
            try resultsData.write(to: savedResultsURL)
            
        } catch let error {
            print("Error trying to save data! \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistence(){
        do {
            guard let savedResultsURL = savedAlarmURL else { return
            }
            let resultsData = try Data(contentsOf: savedResultsURL)
            let plistDecoder = PropertyListDecoder()
            let decodedResults = try plistDecoder.decode( Dictionary<String, Alarm>.self, from: resultsData)
            savedAlarms = decodedResults
        } catch let error {
            print("Error trying to save data! \(error.localizedDescription)")
        }
    }
    
}

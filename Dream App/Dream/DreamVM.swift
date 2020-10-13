//
//  DreamVM.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/10/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

class DreamViewModel {
    
    static let shared = DreamViewModel()
    var savedDreams : [String: Dream] = [:]
    
    var dreamArray : [Dream] {
        return Array(savedDreams.values).sorted { $0.date > $1.date }
    }
    
    func saveDream(dream: Dream){
        savedDreams[dream.identifier] = dream
        saveToPersistence()
    }
    
    func deleteDream(dream : Dream){
        savedDreams.removeValue(forKey: dream.identifier)
        saveToPersistence()
    }
    
    func updateDream(dream : Dream){
        guard var oldDream = savedDreams[dream.identifier] else { return }
        oldDream.title = dream.title
        oldDream.description = dream.description
        saveToPersistence()
    }
    
    var savedDreamURL : URL?{
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileName = "Dream(Persistence).plist"
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    func saveToPersistence(){
        let plistEncoder = PropertyListEncoder()
        do {
            guard let savedDreamURL = savedDreamURL else { return }
            let resultsData = try plistEncoder.encode(savedDreams)
            try resultsData.write(to: savedDreamURL)
            
        } catch let error {
            print("Error trying to save data! \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistence(){
        do {
            guard let savedDreamURL = savedDreamURL else { return
            }
            let resultsData = try Data(contentsOf: savedDreamURL)
            let plistDecoder = PropertyListDecoder()
            let decodedResults = try plistDecoder.decode( Dictionary<String, Dream>.self, from: resultsData)
            savedDreams = decodedResults
        } catch let error {
            print("Error trying to save data! \(error.localizedDescription)")
        }
    }
}

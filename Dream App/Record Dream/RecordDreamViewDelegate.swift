//
//  RecordDreamViewDelegate.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

protocol RecordDreamViewDelegate: class {
    var audioRecorderHelper: AudioRecorderHelper { get set }
    func toggleRecording()
    func stopRecording()
}
extension RecordDreamViewDelegate {
    func toggleRecording() {
        audioRecorderHelper.toggleRecording()
    }
    func stopRecording() {
        audioRecorderHelper.stopRecording()
    }
}

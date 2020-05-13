//
//  AudioRecorderHelperErrorDelegate.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

/// Delegate protocol for AudioRecorderHelper whose methods are called when errors occur.
protocol AudioRecorderHelperErrorDelegate: class {
    /// Called if an error occurs while starting the audio recording
    func audioRecorderHelperCouldNotStartRecording(_ error: AudioRecorderStartingError)
    /// Called when an audio recorder encounters an encoding error during recording.
    func audioRecorderHelperErrorOccuredWhileRecording(_ error: Error?)
}

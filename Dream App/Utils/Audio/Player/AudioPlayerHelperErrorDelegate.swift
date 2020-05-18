//
//  AudioPlayerHelperErrorDelegate.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/18/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

/// Delegate protocol for AudioRecorderHelper whose methods are called when errors occur.
protocol AudioPlayerHelperErrorDelegate: class {
    /// Called if an error occurs while starting the audio recording
    func audioPlayerHelperCouldNotStartPlaying(_ error: Error)
    /// Called when an audio recorder encounters an encoding error during recording.
    func audioRecorderHelperDecodeErrorOccuredWhilePlaying(_ error: Error?)
}

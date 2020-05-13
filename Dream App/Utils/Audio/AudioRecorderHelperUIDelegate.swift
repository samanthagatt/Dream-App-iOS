//
//  AudioRecorderHelperUIDelegate.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

/// Delegate protocol for AudioRecorderHelper whose methods are called when key events
/// occur during the audio recording process that could benefit from updating the UI.
protocol AudioRecorderHelperUIDelegate: class {
    /// Called when users microphone privacy settings are undetermined
    ///
    /// Can be used to invite the user to tap record again,
    /// since the alert to grant access interrupted them,
    /// and they may not have been ready to record
    func audioRecorderHelperDidAskForPermission(granted: Bool)
    /// Called when user tries to record but has already
    /// denied the app access to the microphone
    func audioRecorderHelperWasDeniedMicrophoneAccess()
    /// Called when recording is started, paused, resumed, and stopped
    ///
    /// Can be used to update UI to provide visual feedback to user
    func audioRecorderHelperRecordingChanged(isRecording: Bool)
    /// Called when timer is running.
    ///
    /// Only called if `AudioRecorderHelper` is initialized with
    /// `shouldUseTimer` equal to `true`.
    func audioRecorderHelperTimerCalled(currentTime: TimeInterval)
    /// Called by the system when a recording is stopped or
    /// has finished due to reaching its time limit.
    /// - Parameters:
    ///     - url: Optional URL where audio recording is stored
    ///     - successfully: True on successful completion of recording;
    ///     false if recording stopped because of an audio encoding error.
    func audioRecorderHelperDidFinishRecording(url: URL, successfully flag: Bool)
}

// Makes didAskForPermission optional by giving it a default that does nothing
extension AudioRecorderHelperUIDelegate {
    func audioRecorderHelperDidAskForPermission(granted: Bool) { }
}

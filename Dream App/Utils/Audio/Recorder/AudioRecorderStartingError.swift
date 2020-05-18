//
//  AudioRecorderStartingError.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

/// Errors that can occur before starting an audio recording.
///
/// Used to provide `AudioRecorderHelperDelegate`'s
/// `couldNotStartRecording` method specific errors
enum AudioRecorderStartingError {
    case nilDocumentsURL
    case nilAudioFormat
    case startAudioRecordingFailed(error: Error)
}
extension AudioRecorderStartingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .nilDocumentsURL:
            return NSLocalizedString("Description of nil documents url", comment: "Getting url for app's main document directory returned nil")
        case .nilAudioFormat:
            return NSLocalizedString("Description of nil audio format", comment: "AVAudioFormat with could not be created with specified sample rate and number of channels")
        case .startAudioRecordingFailed(let error):
            return NSLocalizedString("Description of starting audio recording failure", comment: "AVAudioRecorder could not be initialized with newly created url and AVAudioFormat instance.\nError thrown: \(error)")
            
        }
    }
}

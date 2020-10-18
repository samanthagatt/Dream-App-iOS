//
//  SpeechToTextHelper.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/21/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Speech

enum TranscriptionError {
    case userDenied
    case deviceRestricted
    case unknownAuthorization
    case errorOccurred(error: Error?)
}
extension TranscriptionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userDenied:
            return NSLocalizedString(
                "Description of user denied",
                comment: "Authorization to transcribe speech to text was denied." +
                    "You can change this in your settings."
            )
        case .deviceRestricted:
            return NSLocalizedString(
                "Description of device restriction",
                comment: "Your device is restsricted from transcribing speech to text."
            )
        case .unknownAuthorization:
            return NSLocalizedString(
                "Description of unknown authorization",
                comment: "Transcription from speech to text has not been authorized."
            )
        case .errorOccurred(error: let error):
            return NSLocalizedString(
                "Description of transcription error",
                comment: "An error occurred while transcribing audio file." +
                    "\("\nError: ", error?.localizedDescription)"
            )
        }
    }
}

enum TranscriptionResult {
    /// Transcription was successful
    /// - text: The transcribed text
    case success(text: String)
    /// Transcription failed
    /// - error: Why it failed in the form of a `TranscriptionError`
    case failure(_ error: TranscriptionError)
}

/// Wrapper on `SFSpeechRecognizer` to make transcription from speech to text easier
///
/// - Note: Make sure to add `NSSpeechRecognitionUsageDescription` to plist
/// (e.g. `$(PRODUCT_NAME) needs your permission to use speech recognition so we can transcribe your audio files into text`)
class SpeechToTextHelper {
    private let recognizer = SFSpeechRecognizer()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private let audioEngine = AVAudioEngine()
}

extension SpeechToTextHelper {
    func startSession() throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw TranscriptionError.errorOccurred(error: nil)
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = recognizer?.recognitionTask(
            with: recognitionRequest
        ) { [weak self] result, error in

            var finished = false

            if let result = result {
                print(result.bestTranscription.formattedString)
                finished = result.isFinal
            }

            if error != nil || finished {
                self?.audioEngine.stop()
                self?.audioEngine.inputNode.removeTap(onBus: 0)

                self?.recognitionRequest = nil
                self?.recognitionTask = nil
            }
        }

        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in

            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }
}

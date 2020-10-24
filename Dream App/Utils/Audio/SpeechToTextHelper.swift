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
    private let audioEngine = AVAudioEngine()
    private let recognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
}

extension SpeechToTextHelper {
    /// Transcribes audio in real-time
    /// - parameter completion: Completion handler that will be called when transcription
    /// is complete
    /// - parameter result: Instance of the `TranscriptionResult` enum referring to whether or
    /// not the transcription was successful
    func startTranscribing(completion: @escaping (_ result: TranscriptionResult) -> Void) {
        // Request authorization every time
        // If authorization status has already been determined it won't prompt the user
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            // Move back to main thread so you can update UI after without worrying
            DispatchQueue.main.async {
                switch status {
                // Should not be undetermined after requesting authorization
                case .notDetermined: ()
                case .denied:
                    completion(.failure(.userDenied))
                case .restricted:
                    completion(.failure(.deviceRestricted))
                case .authorized:
                    self?.startSession(completion)
                @unknown default:
                    completion(.failure(.unknownAuthorization))
                }
            }
        }
    }
    /// https://developer.apple.com/documentation/speech/recognizing_speech_in_live_audio
    private func startSession(
        _ completion: @escaping (_ result: TranscriptionResult) -> Void
    ) {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
        }
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            completion(.failure(.errorOccurred(error: error)))
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        guard let recognitionRequest = recognitionRequest else {
            completion(.failure(.errorOccurred(error: nil)))
            return
        }
        audioEngine.inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: audioEngine.inputNode.outputFormat(forBus: 0)
        ) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        recognitionTask = recognizer?.recognitionTask(
            with: recognitionRequest
        ) { [weak self] result, error in
            if let result = result {
                completion(.success(text: result.bestTranscription.formattedString))
            }
            if error != nil || result?.isFinal ?? false {
                self?.audioEngine.stop()
                self?.audioEngine.inputNode.removeTap(onBus: 0)
                self?.recognitionRequest = nil
                self?.recognitionTask = nil
            }
        }
        do {
            try audioEngine.start()
        } catch {
            completion(.failure(.errorOccurred(error: error)))
            return
        }
    }
    func stopTranscribing() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
    }
}

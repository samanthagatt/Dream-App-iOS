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
            return NSLocalizedString("Description of user denied", comment: "Authorization to transcribe speech to text was denied. You can change this in your settings.")
        case .deviceRestricted:
            return NSLocalizedString("Description of device restriction", comment: "Your device is restsricted from transcribing speech to text.")
        case .unknownAuthorization:
            return NSLocalizedString("Description of unknown authorization", comment: "Transcription from speech to text is not authorized.")
        case .errorOccurred(error: let error):
            return NSLocalizedString("Description of transcription error", comment: "An error occurred while transcribing audio file.\("\nError: ", error?.localizedDescription)")
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
struct SpeechToTextHelper {
    private func transcribeAudio(url: URL, _ completion: @escaping (TranscriptionResult) -> Void) {
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: url)
        
        recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            guard let result = result else {
                completion(.failure(.errorOccurred(error: error)))
                return
            }
            if result.isFinal {
                let bestResult = result.bestTranscription.formattedString
                completion(.success(text: bestResult))
            }
        })
    }
    
    /// Transcribes audio file at url containing speech into text
    /// - parameter url: URL pointing to the audio file to transcribe
    /// - parameter completion: Completion handler that will be called when transcription is complete
    /// - parameter result: Instance of the `TranscriptionResult` enum referring to whether or not the transcription was successful
    func transcribe(audio url: URL, _ completion: @escaping (_ result: TranscriptionResult) -> Void) {
        // Request authorization every time
        // If authorization status has already been determined it won't prompt the user
        // Using a struct so no need to capture weak self since it's not being passed by reference
        SFSpeechRecognizer.requestAuthorization { status in
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
                        self.transcribeAudio(url: url, completion)
                    @unknown default:
                        completion(.failure(.unknownAuthorization))
                }
            }
        }
    }
}

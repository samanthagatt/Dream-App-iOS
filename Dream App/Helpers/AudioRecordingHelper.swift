//
//  AudioRecordingHelper.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/11/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import AVFoundation

// MARK: - Audio Recorder Helper Delegate
protocol AudioRecorderHelperDelegate: AVAudioRecorderDelegate {
    /// Function called after the first time the user tries to record audio
    /// and accepts privacy terms
    ///
    /// Can be used to invite the user to tap record again,
    /// since the alert to grant access interrupted them,
    /// and they may not have been ready to record
    func audioRecorderHelperDidAskForPermission(granted: Bool)
    /// Function called when user tries to record
    /// but has already denied the app access to the microphone
    func audioRecorderHelperWasDeniedMicrophoneAccess()
    /// Function called if an error occurs while starting the audio recording
    func audioRecorderHelperCouldNotStartRecording(_ error: AudioRecorderStartingError)
    /// Function called when recording is started, paused, resumed, and stopped
    ///
    /// Can be used to update UI to provide visual feedback to user
    func audioRecorderHelperRecordingChanged(_ audioRecorder: AVAudioRecorder?,
                                             isRecording: Bool)
}

// MARK: Default Implementations for Audio Recorder Helper Delegates
// Default functions do nothing so users can decide which functions
// they want to include in their implementation
extension AudioRecorderHelperDelegate {
    func audioRecorderHelperDidAskForPermission(granted: Bool) { return }
    func audioRecorderHelperWasDeniedMicrophoneAccess() { return }
    func audioRecorderHelperCouldNotStartRecording(_ error: AudioRecorderStartingError) { return }
    func audioRecorderHelperRecordingChanged(_ audioRecorder: AVAudioRecorder?,
                                             isRecording: Bool) { return }
}

// MARK: - Audio Recorder Starting Error
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

// MARK: - Audio Recorder Helper
/// Wrapper on AVAudioRecorder to make recording audio easier
/// - Note: Make sure to add `NSMicrophoneUsageDescription` in your plist
/// (e.g. `$(PRODUCT_NAME) needs your permission to use your device's microphone to create audio recordings`)
class AudioRecorderHelper {
    // MARK: Properties
    private var helperDelegate: AudioRecorderHelperDelegate?
    private var audioRecorder: AVAudioRecorder? {
        didSet {
            audioRecorder?.delegate = helperDelegate
        }
    }
    /// URL for the current recording
    private var recordingURL: URL?
    private var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    private var sampleRate: Double
    private var numberOfChannels: Int
    private let shouldUseTimer: Bool
    private var timer: Timer?
    /// How quickly / often the timer will call delegate method
    private var timerInterval: TimeInterval
    
    // MARK: Init / Deinit
    init(helperDelegate: AudioRecorderHelperDelegate?,
         sampleRate: Double = 44_100,
         numberOfChannels: Int = 1,
         // Timers are expensive so default to false
         shouldUpdateUsingTimer: Bool = false,
         timerInterval: TimeInterval = 0.030) {
        
        self.helperDelegate = helperDelegate
        self.sampleRate = sampleRate
        self.numberOfChannels = numberOfChannels
        self.shouldUseTimer = shouldUpdateUsingTimer
        self.timerInterval = timerInterval
    }
    deinit {
        cancelTimerIfNeeded()
    }
    
    // MARK: Internal Methods
    private func createNewRecordingURL() -> URL? {
        /// URL to mian documents directory of app bundle
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        /// Name of new file being created made from current time in user's timezone
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        // caf extention stands for core audio file
        /// URL of file that will store the recording
        let file = documents?.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        return file
    }
    
    /// Initializes and starts recording to a file in app's main document directory
    private func startRecording() {
        guard let recordingURL = createNewRecordingURL() else {
            helperDelegate?.audioRecorderHelperCouldNotStartRecording(.nilDocumentsURL)
            return
        }
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else {
            helperDelegate?.audioRecorderHelperCouldNotStartRecording(.nilAudioFormat)
            return
        }
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL, format: format)
        } catch {
            helperDelegate?.audioRecorderHelperCouldNotStartRecording(.startAudioRecordingFailed(error: error))
            return
        }
        self.recordingURL = recordingURL
        resumeRecording()
    }
    private func startTimerIfNeeded() {
        if shouldUseTimer {
            // Make sure to cancel a timer before making a new one!
            timer?.invalidate()
            // Using weak self to avoid retain cycle
            timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] (_) in
                // self could be nil if user switches UI screen
                guard let self = self else { return }
                self.helperDelegate?.audioRecorderHelperRecordingChanged(self.audioRecorder, isRecording: self.isRecording)
            }
        }
    }
    
    private func cancelTimerIfNeeded() {
        if shouldUseTimer {
            timer?.invalidate()
            timer = nil
        }
    }
    
    // MARK: Public Methods
    /// Checks user's permission for app to use device's microphone
    func requestPermissionAndStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
            case .undetermined:
                // Request recording permission the first time they try to record something
                AVAudioSession.sharedInstance()
                    .requestRecordPermission { granted in
                        self.helperDelegate?.audioRecorderHelperDidAskForPermission(granted: granted)
                }
            case .denied:
                self.helperDelegate?
                    .audioRecorderHelperWasDeniedMicrophoneAccess()
            case .granted:
                startRecording()
            @unknown default:
                break
        }
    }
    func resumeRecording() {
        audioRecorder?.record()
        helperDelegate?.audioRecorderHelperRecordingChanged(audioRecorder, isRecording: isRecording)
        startTimerIfNeeded()
    }
    func pauseRecording() {
        audioRecorder?.pause()
        helperDelegate?.audioRecorderHelperRecordingChanged(audioRecorder, isRecording: isRecording)
        cancelTimerIfNeeded()
    }
    func stopRecording() {
        // Will call AVAudioPlayerDelegate method (didFinishRecording)
        // No need to make / call specific AudioHelperDelegate method
        audioRecorder?.stop()
        cancelTimerIfNeeded()
    }
}

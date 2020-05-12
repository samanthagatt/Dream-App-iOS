//
//  AudioRecordingHelper.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/11/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import AVFoundation
import os.log

// MARK: - Audio Recorder Helper Delegate
protocol AudioRecorderHelperDelegate: class {
    /// Called after the first time the user tries to record audio
    /// and accepts privacy terms
    ///
    /// Can be used to invite the user to tap record again,
    /// since the alert to grant access interrupted them,
    /// and they may not have been ready to record
    func audioRecorderHelperDidAskForPermission(granted: Bool)
    /// Called when user tries to record but has already
    /// denied the app access to the microphone
    func audioRecorderHelperWasDeniedMicrophoneAccess()
    /// Called if an error occurs while starting the audio recording
    func audioRecorderHelperCouldNotStartRecording(_ error: AudioRecorderStartingError)
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
    /// Called when an audio recorder encounters an encoding error during recording.
    func audioRecorderHelperErrorOccuredWhileRecording(_ error: Error?)
}

// MARK: Default Implementations for Audio Recorder Helper Delegates
// Default functions do nothing so users can decide which functions
// they want to include in their implementation
extension AudioRecorderHelperDelegate {
    func audioRecorderHelperDidAskForPermission(granted: Bool) { return }
    func audioRecorderHelperWasDeniedMicrophoneAccess() { return }
    func audioRecorderHelperCouldNotStartRecording(_ error: AudioRecorderStartingError) { return }
    func audioRecorderHelperRecordingChanged(isRecording: Bool) { return }
    func audioRecorderHelperTimerCalled(currentTime: TimeInterval) { return }
    func audioRecorderHelperDidFinishRecording(url: URL, successfully flag: Bool) { return }
    func audioRecorderHelperErrorOccuredWhileRecording(_ error: Error?) { return }
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
class AudioRecorderHelper: NSObject, AVAudioRecorderDelegate {
    // MARK: Private Properties
    // Weak to avoid retain cycle
    private weak var helperDelegate: AudioRecorderHelperDelegate?
    private var audioRecorder: AVAudioRecorder? {
        didSet {
            audioRecorder?.delegate = self
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
    private let shouldLogErrors: Bool
    private let shouldResumeAfterInterruption: Bool
    
    // MARK: Init / Deinit
    init(helperDelegate: AudioRecorderHelperDelegate?,
         sampleRate: Double = 44_100,
         numberOfChannels: Int = 1,
         // Timers are expensive so default to false
         useTimer: Bool = false,
         timerInterval: TimeInterval = 0.030,
         logErrors: Bool = false,
         resumeAfterInterruption: Bool = true) {
        
        self.helperDelegate = helperDelegate
        self.sampleRate = sampleRate
        self.numberOfChannels = numberOfChannels
        shouldUseTimer = useTimer
        self.timerInterval = timerInterval
        shouldLogErrors = logErrors
        shouldResumeAfterInterruption = resumeAfterInterruption
        
        super.init()
        setupNotifications()
    }
    deinit {
        cancelTimerIfNeeded()
        removeNotifications()
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
        
        #if DEBUG
            print("Audio Recording URL: \(file, defaultString: "Document Directory was nil")")
        #endif
        
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
                self.helperDelegate?.audioRecorderHelperTimerCalled(currentTime: self.audioRecorder?.currentTime ?? 0.0)
            }
        }
    }
    private func cancelTimerIfNeeded() {
        if shouldUseTimer {
            timer?.invalidate()
            timer = nil
        }
    }
    private func setupNotifications() {
        // Get the default notification center instance.
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(handleInterruption),
                       name: AVAudioSession.interruptionNotification,
                       object: nil)
    }
    private func removeNotifications() {
        // Get the default notification center instance.
        let nc = NotificationCenter.default
        nc.removeObserver(self,
                          name: AVAudioSession.interruptionNotification,
                          object: nil)
    }
    /// Checks user's permission for app to use device's microphone
    private func requestPermissionAndStartRecording() {
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
    private func resumeRecording() {
        audioRecorder?.record()
        helperDelegate?.audioRecorderHelperRecordingChanged(isRecording: isRecording)
        startTimerIfNeeded()
    }
    private func pauseRecording() {
        audioRecorder?.pause()
        helperDelegate?.audioRecorderHelperRecordingChanged(isRecording: isRecording)
        cancelTimerIfNeeded()
    }
    private func logErrorIfNeeded(_ error: Error?) {
        if shouldLogErrors {
            os_log(
                "Encoding error occurred while recording\nError: %@\nLocalized Description: %@",
                log: .audioRecording,
                type: .error,
                "\(error, defaultString: "No error")",
                "\(error?.localizedDescription ?? "No localized description")"
            )
        }
    }
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        switch type {
            case .began:
                // Recorder is already paused but invalidateTimer
                // and recording changed delegate method should be called
                pauseRecording()
                return
            case .ended:
               // An interruption ended. Resume playback, if appropriate.
                guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // Interruption ended. Playback should resume.
                    if shouldResumeAfterInterruption {
                        resumeRecording()
                    }
                }
            default: ()
        }
    }
    
    // MARK: Public Methods
    /// Requests permission to record on first call of function.
    /// Toggles pausing and recording on every subsequent call.
    ///
    /// Delegate method `recordingChanged` will be called
    /// when calling this function.
    func toggleRecording() {
        guard let _ = audioRecorder else {
            requestPermissionAndStartRecording()
            return
        }
        isRecording ? pauseRecording() : resumeRecording()
    }
    func stopRecording() {
        // Will call AVAudioPlayerDelegate method (didFinishRecording)
        // No need to make / call specific AudioHelperDelegate method
        audioRecorder?.stop()
        cancelTimerIfNeeded()
    }
}

// Mark: AV Audio Recorder Delegate
// Implemented so the delegate doesn't have to import AVFoundation
extension AudioRecorderHelper {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        helperDelegate?.audioRecorderHelperDidFinishRecording(url: recorder.url, successfully: flag)
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        helperDelegate?.audioRecorderHelperErrorOccuredWhileRecording(error)
        logErrorIfNeeded(error)
    }
}

// MARK: - OSLog
extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "No bundle identifier"

    /// Logs audio recording
    static let audioRecording = OSLog(subsystem: subsystem, category: "Audio Recording")
}

//
//  AudioRecorderHelper.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/11/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import AVFoundation

/// Wrapper on AVAudioRecorder to make recording audio easier
/// - Note: Make sure to add `NSMicrophoneUsageDescription` to plist
/// (e.g. `$(PRODUCT_NAME) needs your permission to use your device's microphone to create audio recordings`)
final class AudioRecorderHelper: NSObject, AVAudioRecorderDelegate {
    // MARK: - Private Properties
    // Weak to avoid retain cycle
    /// `AudioRecorderHelperUIDelegate` whose methods will be called
    private weak var uiDelegate: AudioRecorderHelperUIDelegate?
    /// `AudioRecorderHelperErrorDelegate` whose methods will be called
    private weak var errorDelegate: AudioRecorderHelperErrorDelegate?
    /// Audio recorder to be used throughout recording
    private var audioRecorder: AVAudioRecorder? {
        didSet {
            audioRecorder?.delegate = self
        }
    }
    /// Time limit of recording
    private let timeLimit: TimeInterval?
    /// URL for the current recording
    private var recordingURL: URL?
    /// Computed value to flag if the audio recorder is  recording or not
    private var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    /// Sample rate in Hertz to be used when creating audio format
    private let sampleRate: Double
    /// Number of channels to be used when creating audio format
    private let numberOfChannels: AVAudioChannelCount
    /// Flag to tell if audio recorder helper should create a timer
    /// and call delegate method or not
    ///
    /// Timers are expensive so it should only be set to `true` if necessary
    private let shouldUseTimer: Bool
    /// Timer to be used if `shouldUseTimer` is `true`
    private var timer: Timer?
    /// How quickly / often the timer will call delegate method if
    /// `shouldUseTimer` is `true`
    private let timerInterval: TimeInterval
    /// Flag to tell if audio recorder should resume after being interrupted
    private let shouldResumeAfterInterruption: Bool
    
    // MARK: - Init / Deinit
    init(uiDelegate: AudioRecorderHelperUIDelegate? = nil,
         errorDelegate: AudioRecorderHelperErrorDelegate? = nil,
         timeLimit: TimeInterval? = nil,
         sampleRate: Double = 44_100,
         numberOfChannels: AVAudioChannelCount = 1,
         // Timers are expensive so default to false
         useTimer: Bool = false,
         timerInterval: TimeInterval = 0.030,
         resumeAfterInterruption: Bool = false) {
        
        self.uiDelegate = uiDelegate
        self.errorDelegate = errorDelegate
        self.timeLimit = timeLimit
        self.sampleRate = sampleRate
        self.numberOfChannels = numberOfChannels
        shouldUseTimer = useTimer
        self.timerInterval = timerInterval
        shouldResumeAfterInterruption = resumeAfterInterruption
        
        super.init()
        setupNotifications()
    }
    deinit {
        cancelTimerIfNeeded()
        removeNotifications()
    }
    
    // MARK: - Internal Methods
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
            errorDelegate?.audioRecorderHelper(self, startPlayingDidFailWith: .nilDocumentsURL)
            return
        }
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: numberOfChannels) else {
            errorDelegate?.audioRecorderHelper(self, startPlayingDidFailWith: .nilAudioFormat)
            return
        }
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL, format: format)
        } catch {
            errorDelegate?.audioRecorderHelper(self, startPlayingDidFailWith: .startAudioRecordingFailed(error: error))
            return
        }
        self.recordingURL = recordingURL
        resumeRecording()
    }
    /// Checks user's permission for app to use device's microphone
    private func requestPermissionAndStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
            case .undetermined:
                // Request recording permission the first time they try to record something
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    self.uiDelegate?.audioRecorderHelper(self, didAskForPermission: granted)
                }
            case .denied:
                self.uiDelegate?
                    .audioRecorderHelperWasDeniedMicrophoneAccess()
            case .granted:
                startRecording()
            @unknown default:
                break
        }
    }
    private func resumeRecording() {
        if let duration = timeLimit {
            audioRecorder?.record(forDuration: duration)
        } else {
            audioRecorder?.record()
        }
        uiDelegate?.audioRecorderHelper(self, recordingChanged: isRecording)
        startTimerIfNeeded()
    }
    private func pauseRecording() {
        audioRecorder?.pause()
        uiDelegate?.audioRecorderHelper(self, recordingChanged: isRecording)
        cancelTimerIfNeeded()
    }
    // MARK: Timer
    private func startTimerIfNeeded() {
        if shouldUseTimer {
            // Make sure to cancel a timer before making a new one!
            timer?.invalidate()
            // Using weak self to avoid retain cycle
            timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] (_) in
                // self could be nil if user switches UI screen
                guard let self = self else { return }
                self.uiDelegate?.audioRecorderHelper(self, timerCalled: self.audioRecorder?.currentTime ?? 0.0)
            }
        }
    }
    private func cancelTimerIfNeeded() {
        if shouldUseTimer {
            timer?.invalidate()
            timer = nil
        }
    }
    // MARK: Notifications
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
               // An interruption ended. Resume recording, if appropriate.
                guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // Interruption ended. Recording should resume.
                    if shouldResumeAfterInterruption {
                        resumeRecording()
                    }
                }
            default: ()
        }
    }
    
    // MARK: - Public Methods
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

// MARK: - AV Audio Recorder Delegate
// Implemented so the delegate doesn't have to import AVFoundation
extension AudioRecorderHelper {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        cancelTimerIfNeeded()
        uiDelegate?.audioRecorderHelper(self, didFinishRecording: recorder.url, successfully: flag)
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        // Don't have to call uiDelegate method because audioRecorderDidFinishRecording(_:, successfully:) will be called afterwards
        errorDelegate?.audioRecorderHelper(self, ecodingWhileRecordingDidFailWith: error)
    }
}

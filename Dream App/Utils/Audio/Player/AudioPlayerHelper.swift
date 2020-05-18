//
//  AudioPlayerHelper.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/17/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import AVFoundation

// Wrapper on AVAudioPlayer to make playing audio easier
final class AudioPlayerHelper: NSObject, AVAudioPlayerDelegate {
    // MARK: - Private Properties
    // Weak to avoid retain cycle
    /// `AudioRecorderHelperUIDelegate` whose methods will be called
    private weak var uiDelegate: AudioPlayerHelperUIDelegate?
    /// `AudioRecorderHelperErrorDelegate` whose methods will be called
    private weak var errorDelegate: AudioPlayerHelperErrorDelegate?
    /// Audio player to be used throughout playback
    private var audioPlayer: AVAudioPlayer? {
        didSet {
            audioPlayer?.delegate = self
        }
    }
    /// URL to load and play
    private var urlToLoad: URL?
    /// Computed value to flag if the audio player is  playing or not
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    /// Flag to tell if audio player helper should create a timer
    /// and call delegate method or not
    ///
    /// Timers are expensive so it should only be set to `true` if necessary
    private let shouldUseTimer: Bool
    /// Timer to be used if `shouldUseTimer` is `true`
    private var timer: Timer?
    /// How quickly / often the timer will call delegate method if
    /// `shouldUseTimer` is `true`
    private let timerInterval: TimeInterval
    /// Flag to tell if audio player should resume playing after interruption
    private let shouldResumeAfterInterruption: Bool
    /// Flag to tell if audio player should resume after user scrubs
    private var shouldResumeAfterScrubbing = false
    
    // MARK: - Init / Deinit
    init(uiDelegate: AudioPlayerHelperUIDelegate? = nil,
         errorDelegate: AudioPlayerHelperErrorDelegate? = nil,
         // Timers are expensive so default to false
         useTimer: Bool = false,
         timerInterval: TimeInterval = 0.030,
         resumeAfterInterruption: Bool = true) {
        
        self.uiDelegate = uiDelegate
        self.errorDelegate = errorDelegate
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
    private func resumePlaying() {
        audioPlayer?.play()
        uiDelegate?.audioPlayerHelperPlayingChanged(isPlaying: isPlaying)
        startTimerIfNeeded()
    }
    private func pausePlaying() {
        audioPlayer?.pause()
        cancelTimerIfNeeded()
        uiDelegate?.audioPlayerHelperPlayingChanged(isPlaying: isPlaying)
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
                self.uiDelegate?.audioPlayerHelperTimerCalled(currentTime: self.audioPlayer?.currentTime ?? 0.0, duration: self.audioPlayer?.duration ?? 0.0)
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
                // Player is already paused but invalidateTimer
                // and playingChanged delegate method should be called
                pausePlaying()
                return
            case .ended:
               // An interruption ended. Resume playback, if appropriate.
                guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // Interruption ended. Playback should resume.
                    if shouldResumeAfterInterruption {
                        resumePlaying()
                    }
                }
            default: ()
        }
    }
    
    // MARK: - Public Methods
    /// Sets the url the `AVAudioPlayer` will use to play audio
    /// - parameter url: The URL to the audio recording you wish to play
    /// - Warning: Make sure to call this method before `toggleRecording`
    func load(url: URL) {
        urlToLoad = url
        do {
            guard let url = urlToLoad else { return }
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            uiDelegate?.audioPlayerHelperLoadedURL(duration: audioPlayer?.duration, successfully: true)
        } catch {
            errorDelegate?.audioPlayerHelperCouldNotStartPlaying(error)
            uiDelegate?.audioPlayerHelperLoadedURL(duration: nil, successfully: false)
            return
        }
    }
    /// Loads url on first call of function.
    /// Toggles pausing and playing on every subsequent call.
    ///
    /// Delegate method `recordingChanged` will be called
    /// when calling this function.
    /// - Warning: Make sure `loadURL` has been set prior to calling this function
    func togglePlaying() {
        isPlaying ? pausePlaying() : resumePlaying()
    }
    func scrub(to timeInterval: TimeInterval) {
        if isPlaying {
            pausePlaying()
            shouldResumeAfterScrubbing = true
        }
        audioPlayer?.currentTime = timeInterval
        uiDelegate?.audioPlayerHelperDidScrub(currentTime: audioPlayer?.currentTime ?? 0, duration: audioPlayer?.duration ?? 0)
    }
    func playAfterScrubbing() {
        if shouldResumeAfterScrubbing {
            togglePlaying()
            shouldResumeAfterScrubbing = false
        }
    }
}

// MARK: - AV Audio Player Delegate
// Implemented so the delegate doesn't have to import AVFoundation
extension AudioPlayerHelper {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        cancelTimerIfNeeded()
        uiDelegate?.audioPlayerHelperDidFinishPlaying(duration: audioPlayer?.duration ?? 0)
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        errorDelegate?.audioRecorderHelperDecodeErrorOccuredWhilePlaying(error)
    }
}


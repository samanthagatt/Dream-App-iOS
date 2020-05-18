//
//  AudioPlayerHelperUIDelegate.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/18/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

/// Delegate protocol for AudioRecorderHelper whose methods are called when key events
/// occur during the audio recording process that could benefit from updating the UI.
protocol AudioPlayerHelperUIDelegate: class {
    func audioPlayerHelperLoadedURL(duration: TimeInterval?, successfully flag: Bool)
    /// Called when playback is started, paused, resumed, and stopped
    ///
    /// Can be used to update UI to provide visual feedback to user
    func audioPlayerHelperPlayingChanged(isPlaying: Bool)
    /// Called when timer is running.
    ///
    /// Only called if `AudioPlayerHelper` is initialized with
    /// `shouldUseTimer` equal to `true`.
    func audioPlayerHelperTimerCalled(currentTime: TimeInterval, duration: TimeInterval)
    func audioPlayerHelperDidFinishPlaying(duration: TimeInterval)
    func audioPlayerHelperDidScrub(currentTime: TimeInterval, duration: TimeInterval)
}

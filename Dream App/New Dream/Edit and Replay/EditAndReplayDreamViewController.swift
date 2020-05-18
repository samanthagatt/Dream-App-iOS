//
//  FinishNewDreamViewController.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

final class EditAndReplayDreamViewController: UIViewController, UITextViewDelegate, AudioPlayerHelperUIDelegate {
    /// URL to the recorded dream
    var dreamURL: URL? {
        didSet {
            guard let url = dreamURL else {
                #if DEBUG
                    fatalError("Dream recording url was set to nil!")
                #endif
            }
            audioPlayerHelper.load(url: url)
        }
    }
    private lazy var delegateDataSource = {
        EditDelegateAndDataSource(textViewDelegate: self)
    }()
    private lazy var audioPlayerHelper: AudioPlayerHelper = {
        AudioPlayerHelper(uiDelegate: self,
                          errorDelegate: DreamPlayerErrorDelegate(),
                          useTimer: true)
    }()
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    // MARK: Interface Builder Properties
    @IBOutlet private weak var editDreamTableView: UITableView! {
        didSet {
            editDreamTableView.delegate = delegateDataSource
            editDreamTableView.dataSource = delegateDataSource
        }
    }
    @IBOutlet weak var playButton: RoundedButton!
    @IBOutlet weak var scrubber: UISlider!
    @IBOutlet weak var timeLabel: MonoDigitLabel!
}

// MARK: Interface Builder Actions
extension EditAndReplayDreamViewController {
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction func togglePlaying(_ sender: Any) {
        audioPlayerHelper.togglePlaying()
    }
    @IBAction func updateCurrentTime(_ sender: UISlider) {
        let time = TimeInterval(sender.value)
        audioPlayerHelper.scrub(to: time)
    }
    
    @IBAction func playAfterScrubbing(_ sender: Any) {
        audioPlayerHelper.playAfterScrubbing()
    }
}

// MARK: Text View Delegate
extension EditAndReplayDreamViewController {
    // Updates multiline text view / description input height while user types
    func textViewDidChange(_ textView: UITextView) {
        editDreamTableView.beginUpdates()
        editDreamTableView.endUpdates()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        editDreamTableView.beginUpdates()
        editDreamTableView.endUpdates()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        editDreamTableView.beginUpdates()
        editDreamTableView.endUpdates()
    }
}

// MARK: Audio Player Helper UI Delegate
extension EditAndReplayDreamViewController {
    func audioPlayerHelperLoadedURL(duration: TimeInterval?, successfully flag: Bool) {
        loadViewIfNeeded()
        playButton.isEnabled = true
        timeLabel.text = timeIntervalFormatter.string(from: duration ?? 0) ?? "00:00"
        scrubber.minimumValue = 0
        scrubber.maximumValue = Float(duration ?? 0)
    }
    func audioPlayerHelperPlayingChanged(isPlaying: Bool) {
        playButton.isSelected = isPlaying
    }
    func audioPlayerHelperTimerCalled(currentTime: TimeInterval, duration: TimeInterval) {
        let timeLeft = round(duration) - currentTime
        timeLabel.text = timeIntervalFormatter.string(from: timeLeft) ?? "00:00"
        scrubber.value = Float(currentTime)
    }
    func audioPlayerHelperDidScrub(currentTime: TimeInterval, duration: TimeInterval) {
        let timeLeft = round(duration) - currentTime
        timeLabel.text = timeIntervalFormatter.string(from: timeLeft) ?? "00:00"
    }
    func audioPlayerHelperDidFinishPlaying(duration: TimeInterval) {
        playButton.isSelected = false
        timeLabel.text = timeIntervalFormatter.string(from: duration) ?? "00:00"
        scrubber.value = 0
    }
}

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
            guard let url = dreamURL else { return }
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
    
    
    var keyboardFrame: CGRect? {
        didSet {
            scrollIfNeeded()
        }
    }
    var cursorFrame: CGRect? {
        didSet {
            scrollIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIResponder.
        // keyboardWillShowNotification
        // keyboardDidShowNotification
        // keyboardWillHideNotification
        // keyboardDidHideNotification
        // keyboardDidChangeFrameNotification
        // keyboardWillChangeFrameNotification
        
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(updateKeyboardFrame),
                       name: UIResponder.keyboardWillChangeFrameNotification,
                       object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateKeyboardFrame(_ notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            keyboardFrame = frame.cgRectValue
        }
    }
    
    private func scrollIfNeeded() {
        // Keyboard is visible
        if let keyboardFrame = keyboardFrame {
            // Cursor should be visible (why would the keyboard be up if not?)
            guard var cursorFrame = cursorFrame else { return }
            guard let window = view.window else { return }
            // cursor frame in window coordinate space
            cursorFrame = view.convert(cursorFrame, to: window.coordinateSpace)
            // if cursor frame in inside keyboard frame
            if keyboardFrame.contains(cursorFrame) {
                // Then calculate how far it should scroll up
                /// Highest point of keyboard
                let keyboardY = keyboardFrame.maxY
                /// Lowest point of cursor
                let cursorY = cursorFrame.minY
                // Gotta get lowest point of cursor to be above highest point of keyboard
                let distance = keyboardY - cursorY
                editDreamTableView.setContentOffset(CGPoint(x: 0, y: distance), animated: true)
            }
        }
        // Keyboard is not visible
        // Need to go back to default
    }
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
        if let selectedRange = textView.selectedTextRange {
            let frame = textView.caretRect(for: selectedRange.start)
            cursorFrame = textView.convert(frame, to: view.coordinateSpace)
        }
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
    func audioPlayerHelper(_ audioPlayerHelper: AudioPlayerHelper, loadedAudio duration: TimeInterval?, successfully flag: Bool) {
        loadViewIfNeeded()
        playButton.isEnabled = true
        timeLabel.text = timeIntervalFormatter.string(from: duration ?? 0) ?? "00:00"
        scrubber.minimumValue = 0
        scrubber.maximumValue = Float(duration ?? 0)
    }
    func audioPlayerHelper(_ audioPlayerHelper: AudioPlayerHelper, playingChanged isPlaying: Bool) {
        playButton.isSelected = isPlaying
    }
    func audioPlayerHelper(_ audioPlayerHelper: AudioPlayerHelper, timerCalledAt currentTime: TimeInterval, duration: TimeInterval) {
        let timeLeft = round(duration) - currentTime
        timeLabel.text = timeIntervalFormatter.string(from: timeLeft) ?? "00:00"
        scrubber.value = Float(currentTime)
    }
    func audioPlayerHelper(_ audioPlayerHelper: AudioPlayerHelper, didScrubTo currentTime: TimeInterval, duration: TimeInterval) {
        let timeLeft = round(duration) - currentTime
        timeLabel.text = timeIntervalFormatter.string(from: timeLeft) ?? "00:00"
    }
    func audioPlayerHelper(_ audioPlayerHelper: AudioPlayerHelper, didFinishPlaying duration: TimeInterval) {
        playButton.isSelected = false
        timeLabel.text = timeIntervalFormatter.string(from: duration) ?? "00:00"
        scrubber.value = 0
    }
}

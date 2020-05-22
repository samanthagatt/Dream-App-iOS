//
//  FinishNewDreamViewController.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

final class EditAndReplayDreamViewController: UIViewController, UITextViewDelegate, AudioPlayerHelperUIDelegate {
    
    // MARK: Interface Builder
    @IBOutlet var editAndReplayDreamView: EditAndReplayDreamView!
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        editAndReplayDreamView.endEditing(true)
    }
    
    // MARK: Properties
    /// URL to the recorded dream
    var dreamURL: URL? {
        didSet {
            guard let url = dreamURL else { return }
            audioPlayerHelper.load(url: url)
        }
    }
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
    var keyboardFrame: CGRect? {
        didSet { scrollIfNeeded() }
    }
    var cursorFrame: CGRect? {
        didSet {
            if cursorFrame?.origin.y != oldValue?.origin.y {
                scrollIfNeeded()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editAndReplayDreamView.descriptionField.multilineDelegate = self
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
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            guard let windowY = view.window?.frame.maxY else { return }
            let frameY = frame.cgRectValue.origin.y
            print(windowY, frameY)
            keyboardFrame = windowY > frameY ? frame.cgRectValue : nil
            // TODO: Make it be able to overscroll when keyboard is up but remove the extra padding after it's gone
            // let contentHeight = editAndReplayDreamView.scrollView.contentSize.height
            // editAndReplayDreamView.scrollView.contentSize.height = windowY > frameY ? contentHeight + frame.cgRectValue.height : contentHeight - frame.cgRectValue.height
        }
    }
    
    private func scrollIfNeeded() {
        if let keyboardFrame = keyboardFrame {
            // Cursor frame will only be nil if the user hasn't started typing for the first time yet
            guard var cursorFrame = cursorFrame,
                let window = view.window else { return }
            // cursor frame in window coordinate space so it's the same as keyboard coordinates
            cursorFrame = view.convert(cursorFrame, to: window.coordinateSpace)
            /// Highest point of keyboard
            let keyboardTop = keyboardFrame.origin.y
            /// Lowest point of cursor
            let cursorBottom = cursorFrame.origin.y + cursorFrame.height
            // if cursor frame in inside keyboard frame
            // Cursor frame origin y and x are infinity when user creates a new line
            if cursorFrame.origin.y != .infinity && keyboardTop <= cursorBottom {
                // Then calculate how far it should scroll up
                // Gotta get lowest point of cursor to be above highest point of keyboard
                let distance = cursorBottom - keyboardTop
                // Old offset
                let offset = editAndReplayDreamView.scrollView.contentOffset
                // Add distance to old offset y
                editAndReplayDreamView.scrollView.setContentOffset(CGPoint(x: 0, y: distance + offset.y), animated: false)
            }
            // Keyboard is not visible
            // Need to go back to default
        } else { // Keyboard has been dismissed
            print("No more keyboard!")
        }
    }
}

// MARK: Text View Delegate
extension EditAndReplayDreamViewController {
    func setCursorFrame(_ textView: UITextView) {
        if let selectedRange = textView.selectedTextRange {
            let frame = textView.caretRect(for: selectedRange.start)
            cursorFrame = textView.convert(frame, to: view.coordinateSpace)
        }
    }
    // Updates multiline text view / description input height while user types
    func textViewDidChangeSelection(_ textView: UITextView) {
        setCursorFrame(textView)
    }
}

// MARK: Audio Player Helper UI Delegate
extension EditAndReplayDreamViewController {
    func audioPlayerHelper(_ audioPlayerHelper: AudioPlayerHelper, loadedAudio duration: TimeInterval?, successfully flag: Bool) {
        loadViewIfNeeded()
        editAndReplayDreamView.playButton.isEnabled = true
        editAndReplayDreamView.timeLabel.text = timeIntervalFormatter.string(from: duration ?? 0) ?? "00:00"
        editAndReplayDreamView.scrubber.minimumValue = 0
        editAndReplayDreamView.scrubber.maximumValue = Float(duration ?? 0)
    }
    func audioPlayerHelper(_ audioPlayerHelper: AudioPlayerHelper, playingChanged isPlaying: Bool) {
        editAndReplayDreamView.playButton.isSelected = isPlaying
    }
    func audioPlayerHelper(_ audioPlayerHelper: AudioPlayerHelper, timerCalledAt currentTime: TimeInterval, duration: TimeInterval) {
        let timeLeft = round(duration) - currentTime
        editAndReplayDreamView.timeLabel.text = timeIntervalFormatter.string(from: timeLeft) ?? "00:00"
        editAndReplayDreamView.scrubber.value = Float(currentTime)
    }
    func audioPlayerHelper(_ audioPlayerHelper: AudioPlayerHelper, didScrubTo currentTime: TimeInterval, duration: TimeInterval) {
        let timeLeft = round(duration) - currentTime
        editAndReplayDreamView.timeLabel.text = timeIntervalFormatter.string(from: timeLeft) ?? "00:00"
    }
    func audioPlayerHelper(_ audioPlayerHelper: AudioPlayerHelper, didFinishPlaying duration: TimeInterval) {
        editAndReplayDreamView.playButton.isSelected = false
        editAndReplayDreamView.timeLabel.text = timeIntervalFormatter.string(from: duration) ?? "00:00"
        editAndReplayDreamView.scrubber.value = 0
    }
}

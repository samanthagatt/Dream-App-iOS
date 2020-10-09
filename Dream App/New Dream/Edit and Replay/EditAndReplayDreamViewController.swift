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
            speechToTextHelper.transcribe(audio: url) { result in
                
                switch result {
                case .success(let text):
                    print("Text", text)
                case .failure(let error):
                    print("Error:", error)
                }
            }
        }
    }
    
    let speechToTextHelper = SpeechToTextHelper()
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
    private var kbSize: CGSize?
    private lazy var originalContentInsets: UIEdgeInsets = {
        editDreamTableView.contentInset
    }()
    
    // MARK: Interface Builder Properties
    @IBOutlet private weak var editDreamTableView: UITableView! {
        didSet {
            editDreamTableView.delegate = delegateDataSource
            editDreamTableView.dataSource = delegateDataSource
        }
    }
    @IBOutlet weak var replayView: UIView!
    @IBOutlet weak var playButton: RoundedButton!
    @IBOutlet weak var scrubber: UISlider!
    @IBOutlet weak var timeLabel: MonoDigitLabel!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Life Cycle
extension EditAndReplayDreamViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // So the lazy var is forced to load while the correct content inset is set (without keyboard showing)
        // Hacky way to avoid optional
        _ = originalContentInsets
        
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(addKeyboardContentInset(_:)),
                       name: UIResponder.keyboardWillShowNotification,
                       object: nil)
        nc.addObserver(self,
                       selector: #selector(removeKeyboardContentInset(_:)),
                       name: UIResponder.keyboardWillHideNotification,
                       object: nil)
    }
}

// MARK: Keyboard Handling
extension EditAndReplayDreamViewController {
    @objc func addKeyboardContentInset(_ notification: Notification) {
        if let frameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            kbSize = frameValue.cgRectValue.size
            guard let kbSize = kbSize else { return }
            // Adds 16 points of padding plus the keyboard height minus the height of the view below the textfield
            let bottomPadding = kbSize.height - replayView.frame.size.height + 16
            editDreamTableView.contentInset = UIEdgeInsets(top: originalContentInsets.top, left: originalContentInsets.left, bottom: bottomPadding, right: originalContentInsets.right)
            // if you have the scroll indicator visible you can update its insets too
        }
    }
    
    @objc func removeKeyboardContentInset(_ notification: Notification) {
        kbSize = nil
        editDreamTableView.contentInset = originalContentInsets
        // if you have the scroll indicator visible you can reset its insets too
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

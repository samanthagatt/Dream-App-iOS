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
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func dismissKeyboard(_ sender: Any) {
        editAndReplayDreamView.endEditing(true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let dream = dream {
            DreamViewModel.shared.deleteDream(dream: dream)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let title = editAndReplayDreamView.titleField.text, !title.isEmpty {
            if let dream = dream {
                // Update dream
            } else {
                // New dream
                let dream = Dream(title: title, description: editAndReplayDreamView.descriptionField.text, date: Date(), identifier: UUID().uuidString, recordingURL: dreamURL)
                DreamViewModel.shared.saveDream(dream: dream)
            }
             _ = self.tabBarController?.selectedIndex = 0
        } else {
            presentRecordingErrorAlert()
        }
    }
    
    // MARK: Properties
    
    // This dream object is passed when the user selects dream from dreamWallVC
    var dream : Dream? {
        didSet {
            if !isViewLoaded { return }
            loadElements()
        }
    }
    
    /// URL to the recorded dream
    var dreamURL: URL? {
        didSet {
            guard let url = dreamURL else { return }
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
        editAndReplayDreamView.scrollView.contentInset
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 6
        editAndReplayDreamView.descriptionField.multilineDelegate = self
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
        loadElements()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func addKeyboardContentInset(_ notification: Notification) {
        if let frameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            kbSize = frameValue.cgRectValue.size
            guard let kbSize = kbSize else { return }
            // Adds 16 points of padding plus the keyboard height minus the height of the view below the textfield
            let bottomPadding = kbSize.height - editAndReplayDreamView.replayView.frame.size.height + 16
            editAndReplayDreamView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding, right: 0)
            // if you have the scroll indicator visible you can update its insets too
        }
    }
    
    @objc func removeKeyboardContentInset(_ notification: Notification) {
        kbSize = nil
        editAndReplayDreamView.scrollView.contentInset = originalContentInsets
        // if you have the scroll indicator visible you can reset its insets too
    }
}

extension EditAndReplayDreamViewController {
    private func presentRecordingErrorAlert() {
        let dismissAction = UIAlertAction(title: "Dismiss",
                                          style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        presentAlert(for: "Missing Dream Title",
                     message: "Please add title to save dream",
                     actions: dismissAction)
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

private extension EditAndReplayDreamViewController {
    func loadElements(){
        guard let _ = dream else { return }
        saveButton.setTitle("Update", for: .normal)
        
    }
}

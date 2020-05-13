//
//  ViewController.swift
//  Dream App
//
//  Created by Samantha Gatt on 3/24/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

final class RecordDreamViewController: UIViewController, AudioRecorderHelperUIDelegate {
    /// Enum for the possible states of the view controller
    private enum RecordingState {
        case initial
        case recording
        case paused
    }
    
    // MARK: - Private Properties
    private lazy var audioRecorderHelper: AudioRecorderHelper = {
        AudioRecorderHelper(uiDelegate: self,
                            errorDelegate: DreamRecorderErrorDelegate(),
                            useTimer: true,
                            timerInterval: 0.08)
    }()
    private var recordingState: RecordingState = .initial {
        didSet {
            updateViewsOnRecordingStateChange()
        }
    }
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()

    // MARK: - Interface Builder
    @IBOutlet private weak var recordingStateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var doneButton: UIButton!
    
    @IBAction private func toggleRecording(_ sender: UIButton) {
        audioRecorderHelper.toggleRecording()
    }
    @IBAction private func saveRecording(_ sender: UIButton) {
        disableRecordButton()
        audioRecorderHelper.stopRecording()
    }
}

// MARK: - UI Methods
extension RecordDreamViewController {
    // TODO: Make a view with these functions (up to end todo comment)
    private func updateViewsForInitial() {
        // Keeps label in stack view using whitespace
        recordingStateLabel.text = " "
        timeLabel.text = "Record"
        // Changes image to mic.fill
        buttonImage.isHighlighted = false
        descriptionLabel.text = "Press the above button to begin recording your dream. Press again to pause."
        doneButton.isEnabled = false
        // Makes button invisible but keeps it in stack view
        doneButton.alpha = 0
    }
    private func updateViewsForRecording() {
        recordingStateLabel.text = "Recording..."
        // Changes image to pause
        buttonImage.isHighlighted = true
        descriptionLabel.text = "Press the button above to pause recording, a button will appear when you are done."
        doneButton.isEnabled = false
        // Makes button invisible but keeps it in stack view
        doneButton.alpha = 0
    }
    private func updateViewsForPaused() {
        recordingStateLabel.text = "Paused"
        // Changes image to mic.fill
        buttonImage.isHighlighted = false
        descriptionLabel.text = "Press the button above to continue recording, or the button below if you are done."
        doneButton.isEnabled = true
        // Makes sure button is visible
        doneButton.alpha = 1
    }
    private func updateViewsOnRecordingStateChange() {
        switch recordingState {
            case .initial:
                updateViewsForInitial()
            case .recording:
                updateViewsForRecording()
            case .paused:
                updateViewsForPaused()
        }
    }
    // end todo
    private func makeLabelFontsAccessible() {
        recordingStateLabel.font = UIFontMetrics(forTextStyle: .title1)
            .scaledFont(for: recordingStateLabel.font)
        timeLabel.font = UIFontMetrics(forTextStyle: .largeTitle)
            .scaledFont(for: timeLabel.font)
        descriptionLabel.font = UIFontMetrics(forTextStyle: .body)
            .scaledFont(for: descriptionLabel.font)
    }
    private func disableRecordButton() {
        recordButton.isEnabled = false
        recordButton.alpha = 0.6
        buttonImage.alpha = 0.6
    }
}

// MARK: - Life Cycle
extension RecordDreamViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        makeLabelFontsAccessible()
        updateViewsOnRecordingStateChange()
    }
}

// MARK: - Audio Recorder Helper Delegate
extension RecordDreamViewController {
    func audioRecorderHelperDidAskForPermission(granted: Bool) { }
    func audioRecorderHelperRecordingChanged(isRecording: Bool) {
        recordingState = isRecording ? .recording : .paused
    }
    func audioRecorderHelperTimerCalled(currentTime: TimeInterval) {
        timeLabel.text = timeIntervalFormatter.string(from: currentTime) ?? "00:00"
    }
    func audioRecorderHelperDidFinishRecording(url: URL, successfully flag: Bool) {
        if flag {
            // TODO: Pass url to new VC and present it
        } else {
            // TODO: Present error alert and dismiss VC
        }
    }
    func audioRecorderHelperWasDeniedMicrophoneAccess() {
        let alertController = UIAlertController(title: "Microphone Access Denied", message: "Please allow this app to use your microphone so you can record your dreams!", preferredStyle: .alert)
        let openSettingsAction = UIAlertAction(title: "Open Settings",
                                               style: .default) { (_) in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(openSettingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

//
//  ViewController.swift
//  Dream App
//
//  Created by Samantha Gatt on 3/24/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

final class ViewController: UIViewController, AudioRecorderHelperDelegate {
    
    /// Enum for the possible states of the view controller
    private enum RecordingState {
        case initial
        case recording
        case paused
    }
    
    // MARK: Properties
    private lazy var audioRecordingHelper: AudioRecorderHelper = {
        AudioRecorderHelper(helperDelegate: self)
    }()
    private var recordingState: RecordingState = .initial {
        didSet {
            updateViewsOnRecordingStateChange()
            switch oldValue {
                case .initial:
                    audioRecordingHelper.requestPermissionAndStartRecording()
                case .recording:
                    audioRecordingHelper.pauseRecording()
                case .paused:
                    audioRecordingHelper.resumeRecording()
            }
        }
    }

    // MARK: Interface Builder
    @IBOutlet private weak var recordingStateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var doneButton: UIButton!
    
    @IBAction private func changeRecordingState(_ sender: UIButton) {
        switch recordingState {
            case .initial, .paused:
                recordingState = .recording
            case .recording:
                recordingState = .paused
        }
    }
    @IBAction private func saveRecording(_ sender: UIButton) {
        recordButton.isEnabled = false
        audioRecordingHelper.stopRecording()
    }
}

// MARK: Methods
extension ViewController {
    private func updateViewsOnRecordingStateChange() {
        switch recordingState {
            case .initial:
                recordingStateLabel.text = ""
                timeLabel.text = "Record"
                // changes image to mic.fill
                buttonImage.isHighlighted = false
                descriptionLabel.text = "Press the above button to begin recording your dream. Press again to pause."
                doneButton.isEnabled = false
                // Makes button invisible but keeps it in stack view
                doneButton.alpha = 0
            
            case .recording:
                // changes image to pause
                buttonImage.isHighlighted = true
                descriptionLabel.text = "Press the button above to pause recording, a button will appear when you are done."
                doneButton.isEnabled = false
                // Makes button invisible but keeps it in stack view
                doneButton.alpha = 0
            
            case .paused:
                // changes image to mic.fill
                buttonImage.isHighlighted = false
                descriptionLabel.text = "Press the button above to continue recording, or the button below if you are done."
                doneButton.isEnabled = true
                // Makes sure button is visible
                doneButton.alpha = 1
        }
    }
}

// MARK: Life Cycle
extension ViewController {
    private func makeLabelFontsAccessible() {
        recordingStateLabel.font = UIFontMetrics(forTextStyle: .title1)
            .scaledFont(for: recordingStateLabel.font)
        timeLabel.font = UIFontMetrics(forTextStyle: .largeTitle)
            .scaledFont(for: timeLabel.font)
        descriptionLabel.font = UIFontMetrics(forTextStyle: .body)
            .scaledFont(for: descriptionLabel.font)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeLabelFontsAccessible()
        updateViewsOnRecordingStateChange()
    }
}

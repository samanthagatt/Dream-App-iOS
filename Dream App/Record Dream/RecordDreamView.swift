//
//  RecordDreamView.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

class RecordDreamView: UIView {
    /// Enum for the possible states of the view
    enum RecordingState {
        case initial
        case recording
        case paused
        case stopped
    }
    
    // MARK: - Properties
    weak var delegate: RecordDreamViewDelegate?
    var recordingState: RecordingState = .initial {
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
        delegate?.toggleRecording()
    }
    @IBAction private func saveRecording(_ sender: UIButton) {
        recordingState = .stopped
        delegate?.stopRecording()
    }
    
    // MARK: - Private Methods
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
    private func disableRecordButton() {
        recordButton.isEnabled = false
        recordButton.alpha = 0.6
        buttonImage.alpha = 0.6
    }
    private func updateViewsOnRecordingStateChange() {
        switch recordingState {
            case .recording:
                updateViewsForRecording()
            case .paused:
                updateViewsForPaused()
            case .stopped:
                disableRecordButton()
            default: ()
        }
    }
    
    // MARK: - Public Methods
    func updateTimeLabel(currentTime: TimeInterval) {
        timeLabel.text = timeIntervalFormatter.string(from: currentTime) ?? "00:00"
    }
}

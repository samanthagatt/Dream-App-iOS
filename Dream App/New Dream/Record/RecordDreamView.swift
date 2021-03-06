//
//  RecordDreamView.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

final class RecordDreamView: UIView {
    // MARK: Properties
    weak var recorderHelper: AudioRecorderHelper?
    var recordingState: RecordingState = .initial {
        didSet {
            updateViewsOnRecordingStateChange()
        }
    }
//    let transcriptionHelper = SpeechToTextHelper()
    var fullText: [String] = []
    var transcribedText: String {
        fullText.joined(separator: " ")
    }
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    // MARK: Interface Builder
    @IBOutlet private weak var recordingStateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet weak var skipRecordButton: UIButton!
    
    @IBAction private func toggleRecording(_ sender: UIButton) {
        recorderHelper?.toggleRecording()
    }
    
    @IBAction func skiprecordButtonTapped(_ sender: UIButton) {
//         doneButton.isEnabled = true
//         recordingState = .stopped
         //recorderHelper?.stopRecording()
       
    }
    
    @IBAction private func saveRecording(_ sender: UIButton) {
        recordingState = .stopped
        recorderHelper?.stopRecording()
    }
    
    // MARK: Subviews
    let circleView = UIView().addStyling(
        backgroundColor: .darkBackground,
        cornerRadius: 10,
        borderWidth: 2,
        borderColor: .primaryPurple
    )
}

// MARK: RecordingState Enum
extension RecordDreamView {
    /// Enum for the possible states of the view
    enum RecordingState {
        case initial
        case recording
        case paused
        case stopped
    }
}

// MARK: Private Methods
extension RecordDreamView {
    
    private func updateForNewRecord() {
        buttonImage.isHighlighted = false
        descriptionLabel.text = "Tap the above button to begin recording your dream. Press again to pause."
        doneButton.isEnabled = false
        doneButton.alpha = 0
        recordingStateLabel.text = ""
        timeLabel.text = "Record"
        recordButton.isEnabled = true
        recordButton.alpha = 1
        buttonImage.alpha = 1
        circleView.layer.removeAllAnimations()
    }
    
    private func updateViewsForRecording() {
        skipRecordButton.isHidden = true
        recordingStateLabel.text = "Recording..."
        // Changes image to pause
        buttonImage.isHighlighted = true
        descriptionLabel.text = "Tap the button above to pause recording, a button will appear when you are done."
        doneButton.isEnabled = false
        // Makes button invisible but keeps it in stack view
        doneButton.alpha = 0
        circleView.pulsate()
    }
    private func updateViewsForPaused() {
        recordingStateLabel.text = "Paused"
        // Changes image to mic.fill
        buttonImage.isHighlighted = false
        descriptionLabel.text = "Tap the button above to continue recording, or the button below if you are done."
        doneButton.isEnabled = true
        // Makes sure button is visible
        doneButton.alpha = 1
        circleView.layer.removeAllAnimations()
    }
    private func disableRecordButton() {
        recordButton.isEnabled = false
        recordButton.alpha = 0.6
        buttonImage.alpha = 0.6
        circleView.layer.removeAllAnimations()
    }
    private func updateViewsOnRecordingStateChange() {
        switch recordingState {
        case .initial:
            skipRecordButton.isHidden = false
            break
        case .recording:
//            transcriptionHelper.startTranscribing(onlyFinal: true) { [weak self] result in
//                switch result {
//                case .success(text: let text):
//                    self?.fullText.append(text)
//                // print(self?.transcribedText ?? "no self")
//                case .failure(let error):
//                    print(error)
//                }
//            }
            break
        case .paused, .stopped:
//            transcriptionHelper.stopTranscribing()
            break
        }
        switch recordingState {
        case .recording:
            updateViewsForRecording()
        case .paused:
            updateViewsForPaused()
        case .stopped:
            disableRecordButton()
        default:
            updateForNewRecord()
        }
    }
}
// MARK: Public Methods
extension RecordDreamView {
    func updateTimeLabel(currentTime: TimeInterval) {
        timeLabel.text = timeIntervalFormatter.string(from: currentTime) ?? "00:00"
    }
}

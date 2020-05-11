//
//  ViewController.swift
//  Dream App
//
//  Created by Samantha Gatt on 3/24/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    /// Enum for the possible states of the view controller
    private enum RecordingState {
        case initial
        case recording
        case paused
    }
    
    // MARK: Properties
    private var recordingState: RecordingState = .initial {
        didSet {
            updateLabelsAndButtons()
        }
    }
    
    // MARK: Methods
    private func updateLabelsAndButtons() {
        switch recordingState {
            case .initial:
                recordingStateLabel.text = ""
                timeLabel.text = "Record"
                buttonImage.image = UIImage(named: "microphone")
                descriptionLabel.text = "Press the above button to begin recording your dream."
            case .recording:
                buttonImage.image = UIImage(named: "pause")
                descriptionLabel.text = "Press the button above to pause recording, a button will appear when you are done."
            case .paused:
                buttonImage.image = UIImage(named: "microphone")
                descriptionLabel.text = "Press the button above to continue recording, or the button below if you are done."
        }
    }

    // MARK: Interface Builder
    @IBOutlet private weak var recordingStateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
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
        updateLabelsAndButtons()
    }
}

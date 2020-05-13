//
//  ViewController.swift
//  Dream App
//
//  Created by Samantha Gatt on 3/24/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

final class RecordDreamViewController: UIViewController, AudioRecorderHelperUIDelegate, RecordDreamViewDelegate {
    
    lazy var audioRecorderHelper: AudioRecorderHelper = {
        AudioRecorderHelper(uiDelegate: self,
                            errorDelegate: DreamRecorderErrorDelegate(),
                            useTimer: true,
                            timerInterval: 0.08)
    }()
    
    @IBOutlet var recordDreamView: RecordDreamView!
    
    private func createMicDeniedAlert() {
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

// MARK: Life Cycle
extension RecordDreamViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        recordDreamView.delegate = self
    }
}

// MARK: Audio Recorder Helper Delegate
extension RecordDreamViewController {
    func audioRecorderHelperRecordingChanged(isRecording: Bool) {
        recordDreamView.recordingState = isRecording ? .recording : .paused
    }
    func audioRecorderHelperTimerCalled(currentTime: TimeInterval) {
        recordDreamView.updateTimeLabel(currentTime: currentTime)
    }
    func audioRecorderHelperDidFinishRecording(url: URL, successfully flag: Bool) {
        if flag {
            // TODO: Pass url to new VC and present it
        } else {
            // TODO: Present error alert and dismiss VC
        }
    }
    func audioRecorderHelperWasDeniedMicrophoneAccess() {
        createMicDeniedAlert()
    }
}

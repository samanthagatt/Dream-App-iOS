//
//  ViewController.swift
//  Dream App
//
//  Created by Samantha Gatt on 3/24/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

final class RecordDreamViewController: UIViewController, AudioRecorderHelperUIDelegate {
    
    /// How long an audio recording can be
    private let timeLimit = 300.0
    lazy var audioRecorderHelper: AudioRecorderHelper = {
        AudioRecorderHelper(uiDelegate: self,
                            errorDelegate: DreamRecorderErrorDelegate(),
                            timeLimit: timeLimit,
                            useTimer: true,
                            timerInterval: 0.08)
    }()
    
    @IBOutlet var recordDreamView: RecordDreamView! {
        didSet {
            recordDreamView.recorderHelper = audioRecorderHelper
        }
    }
    
    private func performShowRecordingDetailSegue(url: URL) {
        performSegue(withIdentifier: "showRecordingDetail", sender: url)
    }
    
  // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        recordDreamView.recordingState = .initial
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        recordDreamView.circleView.layer.cornerRadius = recordDreamView.circleView.frame.height * 0.50
    }
    
}

// MARK: Alert Controllers
extension RecordDreamViewController {
    private func presentMicDeniedAlert() {
        let settingsAction = UIAlertAction(title: "Open Settings",
                                           style: .default) { (_) in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        presentAlert(for: "Microphone Access Denied",
                     message: "Please allow this app to use your microphone so you can record your dreams!",
                     actions: settingsAction, cancelAction)
    }
    private func presentRecordingStoppedAlert(url: URL) {
        let continueAction = UIAlertAction(title: "Continue",
                                           style: .default) { _ in
            self.performShowRecordingDetailSegue(url: url)
        }
        presentAlert(for: "You've reached your time limit",
                     message: "Your recording can only be \(timeLimit) seconds long",
                     actions: continueAction)
    }
    private func presentRecordingErrorAlert() {
        let dismissAction = UIAlertAction(title: "Dismiss",
                                          style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        presentAlert(for: "An error occurred",
                     message: "Your recording could not be saved",
                     actions: dismissAction)
    }
}

// MARK: Prepare for Segue
extension RecordDreamViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecordingDetail" {
            guard let url = sender as? URL,
                let destVC = segue.destination as? EditAndReplayDreamViewController else { return }
            destVC.dreamURL = url
        }
    }
}

// MARK: Audio Recorder Helper Delegate
extension RecordDreamViewController {
    func audioRecorderHelper(_ audiRecorderHelper: AudioRecorderHelper, recordingChanged isRecording: Bool) {
        recordDreamView.recordingState = isRecording ? .recording : .paused
    }
    func audioRecorderHelper(_ audiRecorderHelper: AudioRecorderHelper, timerCalled currentTime: TimeInterval) {
        recordDreamView.updateTimeLabel(currentTime: currentTime)
    }
    func audioRecorderHelper(_ audiRecorderHelper: AudioRecorderHelper, didFinishRecording url: URL, successfully flag: Bool) {
        // If unsuccessful
        if !flag {
            presentRecordingErrorAlert()
        } else {
            // If successful but recording was not stopped as a result
            // of pushing done button
            guard recordDreamView.recordingState == .stopped else {
                recordDreamView.recordingState = .stopped
                presentRecordingStoppedAlert(url: url)
                return
            }
            // User pushed done button and recording finished successfully
            performShowRecordingDetailSegue(url: url)
        }
    }
    func audioRecorderHelperWasDeniedMicrophoneAccess() {
        presentMicDeniedAlert()
    }
}

// MARK: Audio Recorder Helper Delegate
private extension RecordDreamViewController {
    func setupView(){
        view.addSubviews(recordDreamView.circleView)
        view.sendSubviewToBack(recordDreamView.circleView)
        recordDreamView.circleView.constrainCenter(to: recordDreamView.recordButton)
       // recordDreamView.circleView.constrainSize(width: 350, height: 300)
        recordDreamView.circleView.constrainWidth(to: recordDreamView.recordButton, constant: 32)
        recordDreamView.circleView.constrainHeight(to: recordDreamView.recordButton, constant: 32)
    }
}

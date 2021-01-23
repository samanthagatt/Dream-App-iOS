//
//  ViewController.swift
//  Dream App
//
//  Created by Samantha Gatt on 3/24/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

struct RecordedDream {
    var url: URL?
    var text: String?
}

final class RecordDreamViewController: UIViewController, AudioRecorderHelperUIDelegate, DreamViewModelContainable {
    
    // MARK: - Properties -
    var dreamViewModel: DreamViewModel?
    /// How long an audio recording can be
    private let timeLimit = 300.0
    private lazy var audioRecorderHelper: AudioRecorderHelper = {
        AudioRecorderHelper(
            uiDelegate: self,
            errorDelegate: DreamRecorderErrorDelegate(),
            timeLimit: timeLimit,
            useTimer: true,
            timerInterval: 0.08
        )
    }()
    @IBOutlet var recordDreamView: RecordDreamView! {
        didSet {
            recordDreamView.recorderHelper = audioRecorderHelper
        }
    }
    
    // MARK: - Methods -
    private func setupView() {
        view.addSubviews(recordDreamView.circleView)
        view.sendSubviewToBack(recordDreamView.circleView)
        recordDreamView.circleView.constrainCenter(to: recordDreamView.recordButton)
        recordDreamView.circleView.constrainWidth(to: recordDreamView.recordButton, constant: 10)
        recordDreamView.circleView.constrainHeight(to: recordDreamView.recordButton, constant: 10)
    }
    private func performShowRecordingDetailSegue(dream: RecordedDream) {
        performSegue(withIdentifier: "showRecordingDetail", sender: dream)
    }
    
    @IBAction func skipRecordButtonTapped(_ sender: Any) {
        performShowRecordingDetailSegue(dream: RecordedDream(url: nil, text: nil))
    }
    
    
  // MARK: - Life Cycle -
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

// MARK: - Alert Controllers -
extension RecordDreamViewController {
    private func presentMicDeniedAlert() {
        let settingsAction = UIAlertAction(
            title: "Open Settings",
            style: .default
        ) { (_) in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        presentAlert(
            for: "Microphone Access Denied",
            message: "Please allow this app to use your microphone so you can record your dreams!",
            actions: settingsAction, cancelAction
        )
    }
    private func presentRecordingStoppedAlert(url: URL) {
        let continueAction = UIAlertAction(
            title: "Continue",
            style: .default
        ) { [weak self] _ in
            self?.performShowRecordingDetailSegue(dream: RecordedDream(
                url: url,
                text: self?.recordDreamView.transcribedText ?? "self is nil"
            ))
        }
        presentAlert(
            for: "You've reached your time limit",
            message: "Your recording can only be \(timeLimit) seconds long",
            actions: continueAction
        )
    }
    private func presentRecordingErrorAlert() {
        let dismissAction = UIAlertAction(
            title: "Dismiss",
            style: .destructive
        ) { _ in
            self.dismiss(animated: true)
        }
        presentAlert(
            for: "An error occurred",
            message: "Your recording could not be saved",
            actions: dismissAction
        )
    }
}

// MARK: - Prepare for Segue -
extension RecordDreamViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecordingDetail" {
            guard let recordedDream = sender as? RecordedDream,
                let destVC = segue.destination as? EditAndReplayDreamViewController else { return }
            destVC.dreamURL = recordedDream.url
            destVC.transcribedText = recordedDream.text
            destVC.dreamViewModel = dreamViewModel
        }
    }
}

// MARK: - Audio Recorder Helper Delegate -
extension RecordDreamViewController {
    func audioRecorderHelper(
        _ audiRecorderHelper: AudioRecorderHelper,
        recordingChanged isRecording: Bool
    ) {
        recordDreamView.recordingState = isRecording ? .recording : .paused
    }
    func audioRecorderHelper(
        _ audiRecorderHelper: AudioRecorderHelper,
        timerCalled currentTime: TimeInterval
    ) {
        recordDreamView.updateTimeLabel(currentTime: currentTime)
    }
    func audioRecorderHelper(
        _ audiRecorderHelper: AudioRecorderHelper,
        didFinishRecording url: URL,
        successfully flag: Bool
    ) {
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
            performShowRecordingDetailSegue(dream: RecordedDream(
                url: url,
                text: recordDreamView.transcribedText
            ))
        }
        recordDreamView.fullText = []
    }
    func audioRecorderHelperWasDeniedMicrophoneAccess() {
        presentMicDeniedAlert()
    }
}

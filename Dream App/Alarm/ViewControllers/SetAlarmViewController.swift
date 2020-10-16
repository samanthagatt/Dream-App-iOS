//
//  SetAlarmViewController.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/5/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

class SetAlarmViewController: UIViewController {
    // MARK: - Public Properties -
    public var completion: ((Date, String) -> Void)?
    
    // MARK: - Subviews -
    private let alarmView = UIView().addStyling(
        backgroundColor: .darkBackground,
        cornerRadius: 10,
        borderWidth: 0.3,
        borderColor: .lightText
    )
    private let alarmName = UILabel().style(
        text: "Set Alarm",
        font: .avenirNext(ofSize: 17, isBold: true),
        textColor: .white,
        textAlignment: .center
    )
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.datePickerMode = .time
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    private let saveButton = UIButton().style(
        titlesForStates: [("Save", for: .normal)],
        font: .avenirNext(ofSize: 15),
        targets: [(self, action: #selector(saveButtonTapped), for: .touchUpInside)]
    ).addStyling(
        backgroundColor: .primaryPurple,
        cornerRadius: 6
    )
}

// MARK: - Life Cycle -
extension SetAlarmViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.90)
        setupViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Even Handling -
extension SetAlarmViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch? = touches.first
        if touch?.view != alarmView {
             self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Private Methods -
private extension SetAlarmViewController {
    func constrainViews() {
        // alarmView
        alarmView.constrainCenter(to: view)
        alarmView.constrainSize(width: 275, height: 300)
        // alarmName
        alarmName.constrainCenterX(to: alarmView)
        alarmName.constrainTop(toTopOf: alarmView, offset: 30)
        // datePicker
        datePicker.constrainCenter(to: alarmView)
        datePicker.constrainWidth(to: 250)
        datePicker.constrainTop(toBottomOf: alarmName)
        datePicker.constrainBottom(toTopOf: saveButton)
        // saveButton
        saveButton.constrainCenterX(to: alarmView)
        saveButton.constrainBottom(toBottomOf: alarmView, offset: -30)
        saveButton.constrainSize(width: 200, height: 40)
    }
    func setupViews() {
        view.addSubview(alarmView)
        alarmView.addSubviews(alarmName, saveButton, datePicker)
        constrainViews()
    }
    @objc func saveButtonTapped(sender: UIDatePicker) {
         self.dismiss(animated: true, completion: nil)
         let targetTime = datePicker.date
         let identifier = UUID().uuidString
         let alarm = Alarm(date: targetTime, identifier: identifier)
         AlarmViewModel.shared.saveAlarm(alarm: alarm)
         completion?(targetTime, identifier)
    }
}

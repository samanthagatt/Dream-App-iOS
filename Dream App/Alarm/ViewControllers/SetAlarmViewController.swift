//
//  SetAlarmViewController.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/5/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

class SetAlarmViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.90)
        setupViews()
    }
    
    public var completion: ((Date, String) -> Void)?
    
    private func setupViews() {
        view.addSubview(alarmView)
        alarmView.addSubview(alarmName)
        alarmView.addSubview(saveButton)
        alarmView.addSubview(datePicker)
        constrainViews()
    }
    
    private let alarmView = UIView().addStyling(
        backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        cornerRadius: 10,
        borderWidth: 0.3,
        borderColor: #colorLiteral(red: 0.9008167386, green: 0.9078553915, blue: 0.924911201, alpha: 1)
    )
    
    private var alarmName : UILabel = {
        let label = UILabel()
        label.text = "Set Alarm"
        label.font = UIFont(name: "AvenirNext-Bold", size: 17.0)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.datePickerMode = .time
//        datePicker.subviews[0].subviews[1].backgroundColor = UIColor.white
//        datePicker.subviews[0].subviews[2].backgroundColor = UIColor.white
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let saveButton = UIButton().style(
        titlesForStates: [("Save", for: .normal)],
        font: UIFont(name: "AvinirNext", size: 15.0),
        targets: [(self, action: #selector(saveButtonTapped), for: .touchUpInside)]
    ).addStyling(
        backgroundColor: #colorLiteral(red: 0.4251345992, green: 0.3874737918, blue: 0.9996901155, alpha: 1),
        cornerRadius: 6
    )
    
    @objc private func saveButtonTapped(sender: UIDatePicker){
         self.dismiss(animated: true, completion: nil)
         let targetTime = datePicker.date
         let identifier = UUID().uuidString
         let alarm = Alarm(date: targetTime, identifier: identifier)
         AlarmViewModel.shared.saveAlarm(alarm: alarm)
         completion?(targetTime, identifier)
    }
    
    private func constrainViews() {
        // alarmView
        alarmView.constrainCenter(to: view)
        alarmView.constrainSize(width: 350, height: 300)
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
}

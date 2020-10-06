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
    
    override func viewDidAppear(_ animated: Bool) {
        saveButton.backgroundColor = #colorLiteral(red: 0.128567189, green: 0.1434672177, blue: 0.2099123597, alpha: 0.3)
    }
    
    func setupViews(){
        view.addSubview(alarmView)
        alarmView.addSubview(alarmName)
        alarmView.addSubview(saveButton)
        alarmView.addSubview(datePicker)
        constrainViews()
    }
    
    var alarmView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderWidth = 0.3
        view.layer.borderColor = #colorLiteral(red: 0.9008167386, green: 0.9078553915, blue: 0.924911201, alpha: 1)
        return view
    }()
    
    var alarmName : UILabel = {
        let label = UILabel()
        label.text = "Set Alarm"
        label.font = UIFont(name: "AvenirNext-Bold",
        size: 17.0)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.datePickerMode = .time
        datePicker.subviews[0].subviews[1].backgroundColor = UIColor.white
        datePicker.subviews[0].subviews[2].backgroundColor = UIColor.white
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        //datePicker.backgroundColor = .red
        return datePicker
    }()
    
    var saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext",
                                         size: 15.0)
        button.backgroundColor = #colorLiteral(red: 0.128567189, green: 0.1434672177, blue: 0.2099123597, alpha: 0.3)
        
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func datePickerChanged(sender: UIDatePicker){
        saveButton.backgroundColor = #colorLiteral(red: 0.4251345992, green: 0.3874737918, blue: 0.9996901155, alpha: 1)
    }
    
    @objc func saveButtonTapped(sender: UIDatePicker){
         self.dismiss(animated: true, completion: nil)
    }
    
    func constrainViews(){
        NSLayoutConstraint.activate([
            // AlarmView
            alarmView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alarmView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alarmView.heightAnchor.constraint(equalToConstant: 350),
            alarmView.widthAnchor.constraint(equalToConstant: 300),
            
            // AlarmName
            alarmName.centerXAnchor.constraint(equalTo: alarmView.centerXAnchor),
            alarmName.topAnchor.constraint(equalTo: alarmView.topAnchor, constant: 30),
            
            // DatePicker
            datePicker.centerYAnchor.constraint(equalTo: alarmView.centerYAnchor),
            datePicker.centerXAnchor.constraint(equalTo: alarmView.centerXAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: 250),
            //datePicker.heightAnchor.constraint(equalToConstant: 250),
            datePicker.topAnchor.constraint(equalTo: alarmName.bottomAnchor),
            datePicker.bottomAnchor.constraint(equalTo: saveButton.topAnchor),
            
            // SaveButton
            saveButton.centerXAnchor.constraint(equalTo: alarmView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: alarmView.bottomAnchor, constant: -30),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}

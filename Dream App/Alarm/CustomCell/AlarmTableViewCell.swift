//
//  AlarmTableViewCell.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/5/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amLabel: UILabel!
    @IBOutlet weak var switchToggle: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        constrainViews()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var alarm: Alarm? {
        didSet {
            guard let alarm = alarm else { return }
            let date = alarm.date
            let dateFormmatter = DateFormatter()
            dateFormmatter.dateFormat = "h:mm"
            let hour = dateFormmatter.string(from: date)
            dateFormmatter.dateFormat = "a"
            let symbol = dateFormmatter.string(from: date)
            timeLabel.text = hour
            amLabel.text = symbol
            switchToggle.isOn = alarm.isOn
            viewSwitch(mySwitch: switchToggle)
        }
    }
    
    func removeNotification(){
        guard let alarm = alarm else { return }
        AlarmNotofications.shared.removeNotification(with: alarm.identifier)
    }
    
    func addNotification(){
        guard let alarm = alarm else { return }
        AlarmNotofications.shared.sendNotification(with: alarm.date, id: alarm.identifier)
    }
    
    func setupViews(){
        cellView.layer.cornerRadius = 12
        switchToggle.onTintColor = .primaryPurple
        switchToggle.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        amLabel.translatesAutoresizingMaskIntoConstraints = false
        switchToggle.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cellView)
        addSubview(timeLabel)
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            // do your thing
        }
    
    func constrainViews(){
        //ContrainViews
        NSLayoutConstraint.activate([
            // CellView
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cellView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            // TimeLabel
            timeLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10),
            timeLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            
            // Toggle
            switchToggle.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            switchToggle.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -15),
            
            // PM
            amLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            amLabel.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: -8),
        ])
    }
    @objc func switchChanged(mySwitch: UISwitch) {
        guard let alarm = alarm else { return }
        AlarmViewModel.shared.updateAlarm(alarm: alarm)
        viewSwitch(mySwitch: mySwitch)
    }
    
    @objc func viewSwitch(mySwitch : UISwitch){
        if mySwitch.isOn {
            addNotification()
            timeLabel.alpha = 1
            amLabel.alpha = 1
        } else {
            removeNotification()
            timeLabel.alpha = 0.5
            amLabel.alpha = 0.5
        }
    }
}

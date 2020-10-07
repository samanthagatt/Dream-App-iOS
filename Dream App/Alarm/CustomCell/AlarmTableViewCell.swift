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
        // Initialization code
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
    
    func constrainViews(){
        cellView.layer.cornerRadius = 12
        switchToggle.onTintColor = #colorLiteral(red: 0.4238958359, green: 0.3873499036, blue: 0.9998773932, alpha: 1)
        switchToggle.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        guard let alarm = alarm else { return }
        AlarmViewModel.shared.updateAlarm(alarm: alarm)
        if mySwitch.isOn {
            addNotification()
        } else {
            removeNotification()
        }
    }
}

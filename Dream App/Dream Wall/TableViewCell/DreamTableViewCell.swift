//
//  DreamTableViewCell.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/8/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

class DreamTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: AccessibleLabel!
    @IBOutlet weak var dateLabel: AccessibleLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    var dream: Dream? {
          didSet {
              guard let dream = dream else { return }
              titleLabel.text = dream.title
              // Handle date below
//              let date = alarm.date
//              let dateFormmatter = DateFormatter()
//              dateFormmatter.dateFormat = "h:mm"
//              let hour = dateFormmatter.string(from: date)
//              dateFormmatter.dateFormat = "a"
//              let symbol = dateFormmatter.string(from: date)
//              timeLabel.text = hour
//              amLabel.text = symbol
//              switchToggle.isOn = alarm.isOn
          }
      }

}

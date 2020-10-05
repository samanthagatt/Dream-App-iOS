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

        // Configure the view for the selected state
    }
    
    func constrainViews(){
        cellView.layer.cornerRadius = 10
        switchToggle.onTintColor = #colorLiteral(red: 0.4238958359, green: 0.3873499036, blue: 0.9998773932, alpha: 1)
    }
 
}

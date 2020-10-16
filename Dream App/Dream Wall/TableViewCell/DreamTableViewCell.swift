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
    @IBOutlet weak var detailLabel: UILabel!
    
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
           // detailLabel.text = dream.description
            let dateFormmatter = DateFormatter()
            dateFormmatter.dateStyle = .medium
            dateFormmatter.timeStyle = .short
            dateLabel.text = (dateFormmatter.string(from: dream.date))
        }
    }
    
}

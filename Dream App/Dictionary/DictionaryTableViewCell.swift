//
//  DictionaryTableViewCell.swift
//  Dream Studio
//
//  Created by Perez Willie-Nwobu on 2/4/21.
//  Copyright © 2021 Samantha Gatt. All rights reserved.
//

import UIKit

class DictionaryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setup()
        // Configure the view for the selected state
    }

    // MARK: - Interface -
    @IBOutlet weak var wordTitle: UILabel!
    @IBOutlet weak var wordMeaning: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    // MARK: - functions -
    func setup(){
        cellView.layer.cornerRadius = 6
        cellView.addSubviews(wordMeaning)
        wordMeaning.translatesAutoresizingMaskIntoConstraints = false
        wordTitle.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
        constrainViews()
    }
    
    func constrainViews() {
        wordTitle.constrainTop(toTopOf: cellView, offset: 16)
        wordTitle.constrainTrailing(toTrailingOf: cellView, offset : -16)
        wordTitle.constrainLeading(toLeadingOf: cellView, offset : 16)
        
        wordMeaning.constrainBottom(toBottomOf: cellView, offset: -16)
        wordMeaning.constrainTrailing(toTrailingOf: cellView, offset : -16)
        wordMeaning.constrainLeading(toLeadingOf: cellView, offset : 16)
    }
}

//
//  DreamReplayView.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/13/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

@IBDesignable
class DreamReplayView: UIStackView {
    // MARK: Private Properties
    private lazy var playButton: RoundedButton = {
        let button = RoundedButton()
        // Gives it a 1:1 width:height ratio so it will be a circle
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        // Lets scrubber expand in the middle
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        // Adds action for touch up inside
        button.addTarget(nil, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    private lazy var scrubber: UISlider = {
        let slider = UISlider()
        // Lets scrubber expand in the middle
        slider.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return slider
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        // Lets scrubber expand in the middle
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    // MARK: Init and Interface Builder
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }
    
    // MARK: Private Methods
    private func setupViews() {
        addArrangedSubview(playButton)
        addArrangedSubview(scrubber)
        addArrangedSubview(timeLabel)
    }
    @objc private func buttonAction(_ sender: UIButton) {
        
    }
}

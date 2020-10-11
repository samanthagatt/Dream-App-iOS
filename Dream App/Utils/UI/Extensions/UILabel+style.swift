//
//  UILabel+style.swift
//  Dream App
//
//  Created by Samantha Gatt on 10/10/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

extension UILabel {
    /**
     Customizes the style of the UILabel
     
     Use this function when creating a new label
     - Note: Chain `addStyling` `UIView` instance method to customize 'UIView' properties as well
     - Author: Samantha Gatt
     - Parameters:
         text: The current text that is displayed by the label.
        - attributedText: The current styled text that is displayed by the label.
        - font: The font used to display the text.
        - textColor: The color of the text.
        - textAlignment: The technique to use for aligning the text.
        - lineBreakMode: The technique to use for wrapping and truncating the label’s text.
        - numberOfLines: The maximum number of lines to use for rendering text.
        - translatesMask: A Boolean value that determines whether the view’s autoresizing mask
        is translated into Auto Layout constraints.
     */
    @discardableResult
    func style(
        text: String? = nil,
        attributedText: NSAttributedString? = nil,
        font: UIFont, textColor: UIColor,
        textAlignment: NSTextAlignment = .natural,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        numberOfLines: Int = 0,
        translatesMask: Bool = false
    ) -> Self {
        self.text = text
        if let attributedText = attributedText {
            self.attributedText = attributedText
        }
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.lineBreakMode = lineBreakMode
        self.numberOfLines = numberOfLines
        self.translatesAutoresizingMaskIntoConstraints = translatesMask
        return self
    }
}

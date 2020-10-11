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
        - text: The current text that is displayed by the label.
        - attributedText: The current styled text that is displayed by the label.
        - font: The font used to display the text.
        - textColor: The color of the text.
        - textAlignment: The technique to use for aligning the text.
        - lineBreakMode: The technique to use for wrapping and truncating the label’s text.
        - adjustsFontSizeToFitWidth: A Boolean value that determines whether the label reduces the
        text’s font size to fit the title string into the label’s bounding rectangle.
        - allowsDefaultTighteningForTruncation: A Boolean value that determines whether the label
        tightens text before truncating.
        - baselineAdjustment: An option that controls whether the text's baseline remains fixed
        when text needs to shrink to fit in the label.
        - minimumScaleFactor: The minimum scale factor for the label’s text.
        - numberOfLines: The maximum number of lines to use for rendering text.
        - highlightedTextColor: The highlight color for the label’s text.
        - shadowColor: The shadow color of the text.
        - shadowOffset: The shadow offset, in points, for the text.
        - translatesMask: A Boolean value that determines whether the view’s autoresizing mask
        is translated into Auto Layout constraints.
     */
    @discardableResult
    func style(
        text: String? = nil,
        attributedText: NSAttributedString? = nil,
        font: UIFont? = nil,
        textColor: UIColor? = nil,
        textAlignment: NSTextAlignment? = nil,
        lineBreakMode: NSLineBreakMode? = nil,
        adjustsFontSizeToFitWidth: Bool? = nil,
        allowsDefaultTighteningForTruncation: Bool? = nil,
        baselineAdjustment: UIBaselineAdjustment? = nil,
        minimumScaleFactor: CGFloat? = nil,
        numberOfLines: Int? = nil,
        highlightedTextColor: UIColor? = nil,
        shadowColor: UIColor? = nil,
        shadowOffset: CGSize? = nil,
        lineBreakStrategy: NSParagraphStyle.LineBreakStrategy? = nil,
        translatesMask: Bool = false
    ) -> Self {
        if let text = text {
            self.text = text
        }
        if let attributedText = attributedText {
            self.attributedText = attributedText
        }
        if let font = font {
            self.font = font
        }
        if let textColor = textColor {
            self.textColor = textColor
        }
        if let textAlignment = textAlignment{
            self.textAlignment = textAlignment
        }
        if let lineBreakMode = lineBreakMode {
            self.lineBreakMode = lineBreakMode
        }
        if let adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth {
            self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        }
        if let allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation {
            self.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation
        }
        if let baselineAdjustment = baselineAdjustment {
            self.baselineAdjustment = baselineAdjustment
        }
        if let minimumScaleFactor = minimumScaleFactor {
            self.minimumScaleFactor = minimumScaleFactor
        }
        if let numberOfLines = numberOfLines {
            self.numberOfLines = numberOfLines
        }
        if let highlightedTextColor = highlightedTextColor {
            self.highlightedTextColor = highlightedTextColor
        }
        if let shadowColor = shadowColor {
            self.shadowColor = shadowColor
        }
        if let shadowOffset = shadowOffset {
            self.shadowOffset = shadowOffset
        }
        if let lineBreakStrategy = lineBreakStrategy {
            self.lineBreakStrategy = lineBreakStrategy
        }
        self.translatesAutoresizingMaskIntoConstraints = translatesMask
        return self
    }
}

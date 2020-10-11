//
//  UIButton+style.swift
//  Dream App
//
//  Created by Samantha Gatt on 10/10/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

extension UIButton {
    /**
     Customizes the style of the UIButton
     
     Use this function when creating a new button
     - Note: Chain `addStyling` `UIView` instance method to customize 'UIView' properties as well
     - Author: Samantha Gatt
     - Parameters:
        - titlesForStates: Titles for the specified states.
        - attributedTitlesForStates: Styled titles for the specified states.
        - textColorsForStates: Colors of the title to use for the specified states.
        - shadowColorsForStates: Colors of the title shadow to use for the specified states.
        - font: The font used to display the text.
        - contentEdgeInsets: The inset or outset margins for the rectangle surrounding all of
        the button’s content.
        - titleEdgeInsets: The inset or outset margins for the rectangle around the button’s
        title text.
        - imageEdgeInsets: The inset or outset margins for the rectangle around the button’s image.
        - targets: Target objects and action methods to associate with the control.
        - translatesMask: A Boolean value that determines whether the view’s autoresizing mask is
        translated into Auto Layout constraints.
     */
    @discardableResult
    func style(
        titlesForStates: [(String?, for: UIControl.State)] = [],
        attributedTitlesForStates: [(NSAttributedString?, UIControl.State)] = [],
        textColorsForStates: [(UIColor?, UIControl.State)] = [],
        shadowColorsForStates: [(UIColor?, UIControl.State)] = [],
        font: UIFont? = nil,
        contentEdgeInsets: UIEdgeInsets? = nil,
        titleEdgeInsets: UIEdgeInsets? = nil,
        imageEdgeInsets: UIEdgeInsets? = nil,
        targets: [(Any?, action: Selector, for: UIControl.Event)] = [],
        translatesMask: Bool = false
    ) -> Self {
        for (title, state) in titlesForStates {
            self.setTitle(title, for: state)
        }
        for (attributedTitle, state) in attributedTitlesForStates {
            self.setAttributedTitle(attributedTitle, for: state)
        }
        for (color, state) in textColorsForStates {
            self.setTitleColor(color, for: state)
        }
        for (shadowColor, state) in shadowColorsForStates {
            self.setTitleShadowColor(shadowColor, for: state)
        }
        if let font = font {
            self.titleLabel?.font = font
        }
        for (target,  action, event) in targets {
            self.addTarget(target, action: action, for: event)
        }
        if let contentEdgeInsets = contentEdgeInsets {
            self.contentEdgeInsets = contentEdgeInsets
        }
        if let titleEdgeInsets = titleEdgeInsets {
            self.titleEdgeInsets = titleEdgeInsets
        }
        if let imageEdgeInsets = imageEdgeInsets {
            self.imageEdgeInsets = imageEdgeInsets
        }
        self.translatesAutoresizingMaskIntoConstraints = translatesMask
        return self
    }
}

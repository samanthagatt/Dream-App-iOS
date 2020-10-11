//
//  UIButton+style.swift
//  Dream App
//
//  Created by Samantha Gatt on 10/10/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

extension UIButton {
    @discardableResult
    func style(
        titlesForStates: [(String?, UIControl.State)] = [],
        attributedTitlesForStates: [(NSAttributedString?, UIControl.State)] = [],
        textColorsForStates: [(UIColor?, UIControl.State)] = [],
        font: UIFont? = nil,
        shadowColorsForStates: [(UIColor?, UIControl.State)] = [],
        contentEdgeInsets: UIEdgeInsets = .zero,
        titleEdgeInsets: UIEdgeInsets = .zero,
        imageEdgeInsets: UIEdgeInsets = .zero,
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
        self.titleLabel?.font = font
        self.contentEdgeInsets = contentEdgeInsets
        self.titleEdgeInsets = titleEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        self.translatesAutoresizingMaskIntoConstraints = translatesMask
        return self
    }
}

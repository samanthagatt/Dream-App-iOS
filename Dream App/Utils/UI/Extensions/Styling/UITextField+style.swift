//
//  UITextField+style.swift
//  Dream App
//
//  Created by Samantha Gatt on 10/10/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

extension UITextField {
    /**
     Customizes the style of the UITextField
     
     Use this function when creating a new text field
     - Note: Chain `addStyling` `UIView` instance method to customize 'UIView' properties as well
     - Author: Samantha Gatt
     - Parameters:
        - text: The text displayed by the text field.
        - placeholder: The string that is displayed when there is no other text in the text field.
        - font: The font of the text.
        - textColor: The color of the text.
        - textAlignment: The technique to use for aligning the text.
        - borderStyle: The border style used by the text field.
        - keyboardType: The keyboard style associated with the text object.
        - returnKeyType: The visible title of the Return key.
        - textContentType: ndicates the semantic meaning expected by a text-entry area.
        - isSecureTextEntry: Identifies whether the text object should disable text copying and
        in some cases hide the text being entered.
        - autocapitalizationType: The auto-capitalization style for the text object.
        - autocorrectionType: The autocorrection style for the text object.
        - spellCheckingType: The spell-checking style for the text object.
        - delegate: The receiver’s delegate.
        - translatesMask: A Boolean value that determines whether the view’s autoresizing mask is
        translated into Auto Layout constraints.
     */
    @discardableResult
    func style(
        text: String? = nil,
        attributedText: NSAttributedString? = nil,
        placeholder: String? = nil,
        font: UIFont? = nil,
        textColor: UIColor? = nil,
        textAlignment: NSTextAlignment? = nil,
        borderStyle: UITextField.BorderStyle? = nil,
        textContentType: UITextContentType? = nil,
        keyboardType: UIKeyboardType? = nil,
        returnKeyType: UIReturnKeyType? = nil,
        isSecureTextEntry: Bool? = nil,
        autocapitalizationType: UITextAutocapitalizationType? = nil,
        autocorrectionType: UITextAutocorrectionType? = nil,
        spellCheckingType: UITextSpellCheckingType? = nil,
        delegate: UITextFieldDelegate? = nil,
        translatesMask: Bool = false
    ) -> Self {
        if let text = text {
            self.text = text
        }
        if let attributedText = attributedText {
            self.attributedText = attributedText
        }
        if let placeholder = placeholder {
            self.placeholder = placeholder
        }
        if let font = font {
            self.font = font
        }
        if let textColor = textColor {
            self.textColor = textColor
        }
        if let textAlignment = textAlignment {
            self.textAlignment = textAlignment
        }
        if let borderStyle = borderStyle {
            self.borderStyle = borderStyle
        }
        if let textContentType = textContentType {
            self.textContentType = textContentType
        }
        if let keyboardType = keyboardType {
            self.keyboardType = keyboardType
        }
        if let returnKeyType = returnKeyType {
            self.returnKeyType = returnKeyType
        }
        if let isSecureTextEntry = isSecureTextEntry {
            self.isSecureTextEntry = isSecureTextEntry
        }
        if let autocapitalizationType = autocapitalizationType {
            self.autocapitalizationType = autocapitalizationType
        }
        if let autocorrectionType = autocorrectionType {
            self.autocorrectionType = autocorrectionType
        }
        if let spellCheckingType = spellCheckingType {
            self.spellCheckingType = spellCheckingType
        }
        if let delegate = delegate {
            self.delegate = delegate
        }
        self.translatesAutoresizingMaskIntoConstraints = translatesMask
        return self
    }
}

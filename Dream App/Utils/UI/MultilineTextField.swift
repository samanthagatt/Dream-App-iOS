//
//  MultilineTextField.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/14/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

/// A `UITextView` that mimics the behavior of a `UITextField`
/// so it can have multiple lines of input
@IBDesignable
class MultilineTextField: AccessibleTextView, UITextViewDelegate {
    
    /// Delegate you should assign. Don't use regular delegate if you want
    /// the placeholder to appear and dissappear
    weak var multilineDelegate: UITextViewDelegate?
    private var startingColor: UIColor = .black
    
    @IBInspectable private var placeholderText: String = "Enter text here" {
        didSet {
            text = placeholderText
        }
    }
    @IBInspectable private var placeholderColor: UIColor = .lightGray {
        didSet {
            textColor = placeholderColor
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }
    
    private func setupView() {
        delegate = self
        isEditable = true
        isScrollEnabled = false
        startingColor = textColor ?? .black
        tintColor = .primaryPurple
        textColor = .white
    }
    private func setPlaceholder() {
        if text.isEmpty {
            text = placeholderText
            textColor = placeholderColor
        }
    }
    private func resetText() {
        if text == placeholderText {
            text = ""
            textColor = startingColor
        }
        textColor = .white
    }
    
// TODO: Think of another way to do all this below
    func textViewDidEndEditing(_ textView: UITextView) {
        setPlaceholder()
        multilineDelegate?.textViewDidEndEditing?(textView)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        resetText()
        multilineDelegate?.textViewDidBeginEditing?(textView)
    }
}

extension MultilineTextField {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return multilineDelegate?.textViewShouldEndEditing?(textView) ?? true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return multilineDelegate?.textViewShouldEndEditing?(textView) ?? true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return multilineDelegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    func textViewDidChange(_ textView: UITextView) {
        multilineDelegate?.textViewDidChange?(textView)
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        multilineDelegate?.textViewDidChangeSelection?(textView)
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return multilineDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return multilineDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }
}

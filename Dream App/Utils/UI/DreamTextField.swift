//
//  DreamTextField.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/13/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

@IBDesignable
final class DreamTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        borderStyle = .none
        textColor = .white
        backgroundColor = .clear
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.3
        layer.cornerRadius = 6
        let fontToScale = font ?? .preferredFont(forTextStyle: .body)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: fontToScale)
        
        let foregroundAttr = NSAttributedString.Key.foregroundColor
        let foregroundColor = UIColor.white.withAlphaComponent(0.7)
        self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes:[foregroundAttr: foregroundColor])
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

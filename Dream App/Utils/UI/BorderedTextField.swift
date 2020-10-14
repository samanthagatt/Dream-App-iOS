//
//  DreamTextField.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/13/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

@IBDesignable
final class BorderedTextField: UITextField  {
    
    @IBInspectable private var insetTop: CGFloat = 0
    @IBInspectable private var insetRight: CGFloat = 0
    @IBInspectable private var insetBottom: CGFloat = 0
    @IBInspectable private var insetLeft: CGFloat = 0
    
    private var padding: UIEdgeInsets {
        UIEdgeInsets(top: insetTop,
                     left: insetLeft,
                     bottom: insetBottom,
                     right: insetRight)
    }
    
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
        let fontToScale = font ?? .preferredFont(forTextStyle: .body)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: fontToScale)
        
        let foregroundAttr = NSAttributedString.Key.foregroundColor
        let foregroundColor = UIColor.white.withAlphaComponent(0.7)
        self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes:[foregroundAttr: foregroundColor])
        self.tintColor = .primaryPurple
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

//
//  MonoDigitLabel.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/13/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

@IBDesignable
final class MonoDigitLabel: AccessibleLabel {
    private var weight: Weight = .regular
    @IBInspectable private var fontWeight: String {
        get { weight.rawValue }
        set {
            weight = Weight(rawValue: newValue) ?? .regular
            setFont()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setFont()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setFont()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setFont()
    }
    
    func setFont() {
        startingFont = .monospacedDigitSystemFont(ofSize: startingFont.pointSize, weight: weight.toUIFontWeight())
        scaleFont()
    }
}

extension MonoDigitLabel {
    enum Weight: String {
        case black, bold, heavy, light, medium,
            regular, semibold, thin, ultraLight
        
        func toUIFontWeight() -> UIFont.Weight {
            switch self {
            case .black:
                return UIFont.Weight.black
            case .bold:
                return UIFont.Weight.bold
            case .heavy:
                return UIFont.Weight.heavy
            case .light:
                return UIFont.Weight.light
            case .medium:
                return UIFont.Weight.medium
            case .regular:
                return UIFont.Weight.regular
            case .semibold:
                return UIFont.Weight.semibold
            case .thin:
                return UIFont.Weight.thin
            case .ultraLight:
                return UIFont.Weight.ultraLight
            }
        }
    }
}

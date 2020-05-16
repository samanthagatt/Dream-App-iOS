//
//  BorderView.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/15/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

// UIView classes will not have border properties rendered in IB.
// Visualization requires the use of a new class that inherits from
// UIView with a declaration attribute of @IBDesignable
extension UIView {
    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable private var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    @IBInspectable private var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}

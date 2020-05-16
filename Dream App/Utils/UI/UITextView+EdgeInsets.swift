//
//  UITextView+EdgeInsets.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/16/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

extension UITextView {
    @IBInspectable private var insetTop: CGFloat {
        get { textContainerInset.top }
        set { textContainerInset.top = newValue }
    }
    @IBInspectable private var insetRight: CGFloat {
        get { textContainerInset.right }
        set { textContainerInset.right = newValue }
    }
    @IBInspectable private var insetBottom: CGFloat {
        get { textContainerInset.bottom }
        set { textContainerInset.bottom = newValue }
    }
    @IBInspectable private var insetLeft: CGFloat {
        get { textContainerInset.left }
        set { textContainerInset.left = newValue }
    }
}

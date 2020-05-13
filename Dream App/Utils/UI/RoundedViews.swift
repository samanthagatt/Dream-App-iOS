//
//  RoundedViews.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/10/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

extension UIView {
    fileprivate func roundCorners(amount: CGFloat = 2) {
        let shortestEdgeSize = frame.height <= frame.width ? frame.height : frame.width
        layer.cornerRadius = amount < 2 ? 0 :
            max(shortestEdgeSize / amount, 1)
        layer.masksToBounds = true
    }
}

@IBDesignable
class RoundedView: UIView {
    @IBInspectable var roundingAmount: CGFloat = 2
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(amount: roundingAmount)
    }
}

@IBDesignable
class RoundedButton: UIButton {
    @IBInspectable var roundingAmount: CGFloat = 2
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(amount: roundingAmount)
    }
}

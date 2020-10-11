//
//  UIView+addStyling.swift
//  DreamApp
//
//  Created by Samantha Gatt on 7/5/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

extension UIView {
    /**
     Adds styling to any UIView
     
     Use this instance method to add styling to new views
     - Note: Best used by method chaining when creating new views
     - Warning: Resets all properties to their default values if not set
     - Author: Samantha Gatt
     - Parameters:
        - backgroundColor: The view's background color.
        - alpha: The view's alpha value.
        - clipsToBounds: A Boolean value that determines whether subviews are confined to the bounds of the view.
        - mask: An optional view whose alpha channel is used to mask a view’s content.
        - cornerRadius: The radius to use when drawing rounded corners for the layer’s background. Animatable.
        - borderWidth: The width of the layer’s border. Animatable.
        - borderColor: The color of the layer’s border. Animatable.
        - shadowOpacity: The opacity of the layer’s shadow. Animatable.
        - shadowRadius: The blur radius (in points) used to render the layer’s shadow. Animatable.
        - shadowOffset: The offset (in points) of the layer’s shadow. Animatable.
        - shadowColor: The color of the layer’s shadow. Animatable.
        - shadowPath: The shape of the layer’s shadow. Animatable.
        - translatesMask: A Boolean value that determines whether the view’s autoresizing mask
        is translated into Auto Layout constraints.
     - Returns: The original view after styling as a discardable result
     */
    @discardableResult
    func addStyling(
        backgroundColor: UIColor? = nil,
        alpha: CGFloat? = nil,
        clipsToBounds: Bool? = nil,
        mask: UIView? = nil,
        cornerRadius: CGFloat? = nil,
        borderWidth: CGFloat? = nil,
        borderColor: UIColor? = nil,
        shadowOpacity: Float? = nil,
        shadowRadius: CGFloat? = nil,
        shadowOffset: CGSize? = nil,
        shadowColor: UIColor? = nil,
        shadowPath: CGPath? = nil,
        translatesMask: Bool = false
    ) -> Self {
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let alpha = alpha {
            self.alpha = alpha
        }
        if let clipsToBounds = clipsToBounds {
            self.clipsToBounds = clipsToBounds
        }
        if let mask = mask {
            self.mask = mask
        }
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
        if let borderWidth = borderWidth {
            self.layer.borderWidth = borderWidth
        }
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        if let shadowOpacity = shadowOpacity {
            self.layer.shadowOpacity = shadowOpacity
        }
        if let shadowRadius = shadowRadius {
            self.layer.shadowRadius = shadowRadius
        }
        if let shadowOffset = shadowOffset {
            self.layer.shadowOffset = shadowOffset
        }
        if let shadowColor = shadowColor {
            self.layer.shadowColor = shadowColor.cgColor
        }
        if let shadowPath = shadowPath {
            self.layer.shadowPath = shadowPath
        }
        self.translatesAutoresizingMaskIntoConstraints = translatesMask
        return self
    }
}

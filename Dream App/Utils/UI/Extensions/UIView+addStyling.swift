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
     - Returns: The original view after styling as a discardable result
     */
    @discardableResult
    func addStyling(
        backgroundColor: UIColor = .clear,
        alpha: CGFloat = 1,
        clipsToBounds: Bool = false,
        mask: UIView? = nil,
        cornerRadius: CGFloat = 0,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = .clear,
        shadowOpacity: Float = 0,
        shadowRadius: CGFloat = 0,
        shadowOffset: CGSize = .zero,
        shadowColor: UIColor? = nil,
        shadowPath: CGPath? = nil
    ) -> Self {
        self.backgroundColor = backgroundColor
        self.alpha = alpha
        self.clipsToBounds = clipsToBounds
        self.mask = mask
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowColor = shadowColor?.cgColor
        self.layer.shadowPath = shadowPath
        return self
    }
}

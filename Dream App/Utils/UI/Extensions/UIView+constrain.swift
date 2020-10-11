//
//  UIView+constrain.swift
//  Dream App
//
//  Created by Samantha Gatt on 10/11/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    func constrainCenterX(to otherView: UIView, offset: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerXAnchor
            .constraint(equalTo: otherView.centerXAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainCenterY(to otherView: UIView, offset: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerYAnchor
            .constraint(equalTo: otherView.centerYAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainCenter(
        to otherView: UIView,
        xOffset: CGFloat = 0,
        yOffset: CGFloat = 0
    ) -> (centerX: NSLayoutConstraint, centerY: NSLayoutConstraint) {
        (centerX: constrainCenterX(to: otherView, offset: xOffset),
         centerY: constrainCenterY(to: otherView, offset: yOffset))
    }
    @discardableResult
    func constrainCenter(
        to otherView: UIView,
        offset: CGFloat = 0
    ) -> (centerX: NSLayoutConstraint, centerY: NSLayoutConstraint) {
        constrainCenter(to: otherView, xOffset: offset, yOffset: offset)
    }
    @discardableResult
    func constrainTop(toBottomOf otherView: UIView, offset: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: otherView.bottomAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainTop(toTopOf otherView: UIView, offset: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: otherView.topAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainBottom(toTopOf otherView: UIView, offset: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = bottomAnchor
            .constraint(equalTo: otherView.topAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainBottom(toBottomOf otherView: UIView, offset: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = bottomAnchor
            .constraint(equalTo: otherView.bottomAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainLeading(
        toTrailingOf otherView: UIView,
        offset: CGFloat = 0
    ) -> NSLayoutConstraint {
        let constraint = leadingAnchor
            .constraint(equalTo: otherView.trailingAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainLeading(
        toLeadingOf otherView: UIView,
        offset: CGFloat = 0
    ) -> NSLayoutConstraint {
        let constraint = leadingAnchor
            .constraint(equalTo: otherView.leadingAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainTrailing(
        toLeadingOf otherView: UIView,
        offset: CGFloat = 0
    ) -> NSLayoutConstraint {
        let constraint = trailingAnchor
            .constraint(equalTo: otherView.leadingAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainTrailing(
        toTrailingOf otherView: UIView,
        offset: CGFloat = 0
    ) -> NSLayoutConstraint {
        let constraint = trailingAnchor.constraint(equalTo: otherView.trailingAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainTopAndSides(
        to otherView: UIView,
        topPadding: CGFloat = 0,
        leadingPadding: CGFloat = 0,
        trailingPadding: CGFloat = 0
    ) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        (top: constrainTop(toTopOf: otherView, offset: topPadding),
         leading: constrainLeading(toLeadingOf: otherView, offset: leadingPadding),
         trailing: constrainTrailing(toTrailingOf: otherView, offset: -trailingPadding))
    }
    @discardableResult
    func constrainTopAndSides(
        to otherView: UIView,
        padding: CGFloat = 0
    ) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        constrainTopAndSides(
            to: otherView,
            topPadding: padding,
            leadingPadding: padding,
            trailingPadding: padding
        )
    }
    @discardableResult
    func constrainTopAndSides(
        to otherView: UIView,
        topPadding: CGFloat = 0,
        horizontalPadding: CGFloat = 0
    ) -> (top: NSLayoutConstraint, leading: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        constrainTopAndSides(
            to: otherView,
            topPadding: topPadding,
            leadingPadding: horizontalPadding,
            trailingPadding: -horizontalPadding
        )
    }
    @discardableResult
    func constrainWidth(
        to otherView: UIView,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(
            equalTo: otherView.widthAnchor,
            multiplier: multiplier,
            constant: constant
        )
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainHeight(
        to otherView: UIView,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(
            equalTo: otherView.heightAnchor,
            multiplier: multiplier,
            constant: constant
        )
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainWidthAndHeight(
        to otherView: UIView,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0
    ) -> (width: NSLayoutConstraint, height: NSLayoutConstraint) {
        (width: constrainWidth(to: otherView, multiplier: multiplier, constant: constant),
         height: constrainHeight(to: otherView, multiplier: multiplier, constant: constant))
    }
    @discardableResult
    func constrainWidth(to constant: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainheight(to constant: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        return constraint
    }
    @discardableResult
    func constrainSize(
        width: CGFloat,
        height: CGFloat
    ) -> (width: NSLayoutConstraint, height: NSLayoutConstraint) {
        (width: constrainWidth(to: width), height: constrainheight(to: height))
    }
}

//
//  DreamLabel.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/13/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

class AccessibleLabel: UILabel {
    private var startingFont: UIFont = .preferredFont(forTextStyle: .body)
    private var textStyle: UIFont.TextStyle = .body
    @IBInspectable private var fontTextStyle: String {
        get { textStyle.rawValue }
        set {
            let style = AccessibleStyle(rawValue: newValue)
            textStyle = style?.toUIFontTextStyle() ?? .body
            scaleFont()
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        startingFont = font
        scaleFont()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        startingFont = font
        scaleFont()
    }
    func scaleFont() {
        font = UIFontMetrics(forTextStyle: textStyle)
            .scaledFont(for: startingFont)
    }
}

extension AccessibleLabel {
    enum AccessibleStyle: String {
        case body, callout, caption1, caption2, footnote,
            headline, subheadline, largeTitle, title1,
            title2, title3
        
        func toUIFontTextStyle() -> UIFont.TextStyle {
            switch self {
            case .body:
                return UIFont.TextStyle.body
            case .callout:
                return UIFont.TextStyle.callout
            case .caption1:
                return UIFont.TextStyle.caption1
            case .caption2:
                return UIFont.TextStyle.caption2
            case .footnote:
                return UIFont.TextStyle.footnote
            case .headline:
                return UIFont.TextStyle.headline
            case .subheadline:
                return UIFont.TextStyle.subheadline
            case .largeTitle:
                return UIFont.TextStyle.largeTitle
            case .title1:
                return UIFont.TextStyle.title1
            case .title2:
                return UIFont.TextStyle.title2
            case .title3:
                return UIFont.TextStyle.title3
            }
        }
    }
}

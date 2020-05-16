//
//  AccessibleText.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/13/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

protocol AccessibleText: class {
    var font: UIFont? { get set }
    var startingFont: UIFont { get set }
    var textStyle: TextStyle { get set }
    var fontTextStyle: String { get set }
    func scaleFont()
    func setStartingFont(_ font: UIFont?)
}
extension AccessibleText {
    func scaleFont() {
        font = UIFontMetrics(forTextStyle: textStyle.toUIFontTextStyle())
            .scaledFont(for: startingFont)
    }
    func setStartingFont(_ font: UIFont?) {
        startingFont = font ?? .preferredFont(forTextStyle: .body)
    }
}
class AccessibleTextField: UITextField, AccessibleText {
    var startingFont: UIFont = .preferredFont(forTextStyle: .body)
    var textStyle: TextStyle = .body {
        didSet {
            scaleFont()
        }
    }
    @IBInspectable var fontTextStyle: String {
        get { textStyle.rawValue }
        set {
            textStyle = TextStyle(rawValue: newValue) ?? .body
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStartingFont(font)
        scaleFont()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStartingFont(font)
        scaleFont()
    }
}
class AccessibleTextView: UITextView, AccessibleText {
    var startingFont: UIFont = .preferredFont(forTextStyle: .body)
    var textStyle: TextStyle = .body {
        didSet {
            scaleFont()
        }
    }
    @IBInspectable var fontTextStyle: String {
        get { textStyle.rawValue }
        set {
            textStyle = TextStyle(rawValue: newValue) ?? .body
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStartingFont(font)
        scaleFont()
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setStartingFont(font)
        scaleFont()
    }
}

class AccessibleLabel: UILabel {
    var startingFont: UIFont = .preferredFont(forTextStyle: .body)
    var textStyle: TextStyle = .body {
        didSet {
            scaleFont()
        }
    }
    @IBInspectable var fontTextStyle: String {
        get { textStyle.rawValue }
        set {
            textStyle = TextStyle(rawValue: newValue) ?? .body
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
        font = UIFontMetrics(forTextStyle: textStyle.toUIFontTextStyle())
            .scaledFont(for: startingFont)
    }
}

enum TextStyle: String {
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

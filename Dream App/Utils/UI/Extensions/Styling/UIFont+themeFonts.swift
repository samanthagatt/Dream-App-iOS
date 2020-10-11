//
//  UIFont+themeFonts.swift
//  Dream App
//
//  Created by Samantha Gatt on 10/11/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

extension UIFont {
    static func avenirNext(ofSize size: CGFloat, isBold: Bool = false) -> UIFont? {
        UIFont(name: "AvenirNext" + (isBold ? "-Bold" : ""), size: size)
    }
}

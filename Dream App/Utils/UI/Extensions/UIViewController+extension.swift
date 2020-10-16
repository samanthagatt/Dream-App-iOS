//
//  UIViewController+extension.swift
//  Dream App
//
//  Created by Perez Willie Nwobu on 10/15/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

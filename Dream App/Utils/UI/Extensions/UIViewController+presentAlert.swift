//
//  UIViewController+presentAlert.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/13/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(for title: String?,
                      message: String?,
                      style: UIAlertController.Style = .alert,
                      animated: Bool = true,
                      actions: UIAlertAction...) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        if actions.count == 0 {
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
        }
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: animated)
    }
}

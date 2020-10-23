//
//  MainTabBarController.swift
//  Dream App
//
//  Created by Samantha Gatt on 10/22/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

protocol DreamViewModelContainable: NSObject {
    var dreamViewModel: DreamViewModel? { get set }
}

class MainTabBarController: UITabBarController {
    let dreamViewModel = DreamViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in viewControllers ?? [] {
            for childView in view.children {
                if let childView = childView as? DreamViewModelContainable {
                    childView.dreamViewModel = dreamViewModel
                }
            }
        }
    }
}

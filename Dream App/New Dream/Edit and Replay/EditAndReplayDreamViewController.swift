//
//  FinishNewDreamViewController.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

final class EditAndReplayDreamViewController: UIViewController, UITextViewDelegate {
    
    /// URL to the recorded dream
    var dreamURL: URL?
    private lazy var delegateDataSource = {
        EditDelegateAndDataSource(textViewDelegate: self)
    }()
    
    // MARK: Interface Builder
    @IBOutlet private weak var editDreamTableView: UITableView!
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
}

// MARK: Text View Delegate
extension EditAndReplayDreamViewController {
    // Updates multiline text view / description input height while user types
    func textViewDidChange(_ textView: UITextView) {
        editDreamTableView.beginUpdates()
        editDreamTableView.endUpdates()
    }
}

// MARK: Life Cycle
extension EditAndReplayDreamViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        editDreamTableView.delegate = delegateDataSource
        editDreamTableView.dataSource = delegateDataSource
    }
}

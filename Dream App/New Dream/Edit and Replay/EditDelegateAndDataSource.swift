//
//  EditDelegateAndDataSource.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/15/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

final class EditDelegateAndDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var dreamCell: EditDreamCell?
    weak var dreamDescriptionFieldDelegate: UITextViewDelegate?
    
    init(textViewDelegate: UITextViewDelegate) {
        dreamDescriptionFieldDelegate = textViewDelegate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dreamCell = tableView.dequeueReusableCell(withIdentifier: "editDreamCell", for: indexPath) as? EditDreamCell
        dreamCell?.descriptionField.multilineDelegate = dreamDescriptionFieldDelegate
        return dreamCell ?? UITableViewCell()
    }
}

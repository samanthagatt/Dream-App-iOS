//
//  FinishNewDreamViewController.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

class FinishNewDreamViewController: UITableViewController {
    
    /// Table view cell IDs from interface builder
    private let cellIDs = ["descriptionCell", "dreamTitleCell"]
    
    /// URL to the recorded dream
    var dreamURL: URL?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIDs.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellIDs[indexPath.row], for: indexPath)
    }
}

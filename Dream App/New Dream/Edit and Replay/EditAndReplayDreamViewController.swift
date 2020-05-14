//
//  FinishNewDreamViewController.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

class EditAndReplayDreamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /// URL to the recorded dream
    var dreamURL: URL?

    @IBOutlet weak var editDreamTableView: UITableView!
    
    @IBOutlet weak var dreamReplayView: DreamReplayView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "editDreamCell", for: indexPath)
    }
}

//
//  DreamWallViewController.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/8/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit



class DreamWallViewController: UIViewController {
    
    // DummyData
    let arrayOfDreams = [first, second, third, fourth, fifth, sixth, seventh, eighth]
    
    @IBOutlet weak var dreamWallTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dreamWallTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
}

extension DreamWallViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDreams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dreamCell", for: indexPath) as? DreamTableViewCell else { return UITableViewCell() }
        let dream = arrayOfDreams[indexPath.row]
        cell.titleLabel.text = dream.title
        cell.dateLabel.text = dream.date
        return cell
    }
}




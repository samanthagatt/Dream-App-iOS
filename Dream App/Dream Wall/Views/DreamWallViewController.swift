//
//  DreamWallViewController.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/8/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit



class DreamWallViewController: UIViewController {
    @IBOutlet weak var dreamWallTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dreamWallTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupView()
    }
    
    private func setupView(){
        DreamViewModel.shared.loadFromPersistence()
        dreamWallTableView.reloadData()
    }
}

// TableView
extension DreamWallViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DreamViewModel.shared.dreamArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dreamCell", for: indexPath) as? DreamTableViewCell else { return UITableViewCell() }
        cell.dream = DreamViewModel.shared.dreamArray[indexPath.row];        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dream = DreamViewModel.shared.dreamArray[indexPath.row]
            DreamViewModel.shared.deleteDream(dream: dream)
            tableView.deleteRows(at: [indexPath], with: .fade)
            dreamWallTableView.reloadData()
        }
    }
}




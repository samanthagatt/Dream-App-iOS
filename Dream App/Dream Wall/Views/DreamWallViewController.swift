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
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadData()
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

private extension DreamWallViewController {
    func reloadData(){
        DreamViewModel.shared.loadFromPersistence()
        dreamWallTableView.reloadData()
    }
    
    func setupView(){
        dreamWallTableView.separatorStyle = .none
        searchBar.tintColor = #colorLiteral(red: 0.4254588485, green: 0.3910192549, blue: 0.9995513558, alpha: 1)
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
    }
}




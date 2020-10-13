//
//  DreamWallViewController.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/8/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit



class DreamWallViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var dreamWallTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Properties
    var filteredDreams: [Dream] = []
    var isSearching = false
    
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
        
        if isSearching {
            return filteredDreams.count
        } else {
        return DreamViewModel.shared.dreamArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dreamCell", for: indexPath) as? DreamTableViewCell else { return UITableViewCell() }
        if isSearching {
            cell.dream = filteredDreams[indexPath.row]
        } else {
          cell.dream = DreamViewModel.shared.dreamArray[indexPath.row]
        }
        return cell
    }
}

// SearchBar
extension DreamWallViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
               isSearching = false
               dreamWallTableView.reloadData()
           } else {
               isSearching = true
            filteredDreams = DreamViewModel.shared.dreamArray.filter({$0.title.lowercased().contains(searchBar.text?.lowercased() ?? "")})
               dreamWallTableView.reloadData()
           }
    }
}

// Private func
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
        searchBar.delegate = self
    }
}




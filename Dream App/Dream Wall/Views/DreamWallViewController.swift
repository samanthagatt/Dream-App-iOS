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
    @IBAction func newAlarmButtonTapped(_ sender: Any) {
        _ = self.tabBarController?.selectedIndex = 1
    }
    // MARK: - Properties
    var filteredDreams: [Dream] = []
    var isSearching = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadData()
    }
}

// MARK: -TableView
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // 92
        92
    }
}

 
// MARK: Prepare for Segue
 extension DreamWallViewController {
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = dreamWallTableView.indexPathForSelectedRow{
            guard let detailVC = segue.destination as? EditAndReplayDreamViewController else { return }
            if isSearching {
                detailVC.dream = filteredDreams[indexPath.row]
            } else {
                detailVC.dream = DreamViewModel.shared.dreamArray[indexPath.row]
            }
        }
     }
 }

// MARK: - SearchBar
extension DreamWallViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            isSearching = false
            dreamWallTableView.reloadData()
        } else {
            isSearching = true
            filteredDreams = DreamViewModel.shared.dreamArray.filter({$0.title.lowercased().contains(searchBar.text?.lowercased() ?? "") || $0.description.lowercased().contains(searchBar.text?.lowercased() ?? "")})
            dreamWallTableView.reloadData()
        }
    }
}

// MARK: - Private func
private extension DreamWallViewController {
    func reloadData(){
        DreamViewModel.shared.loadFromPersistence()
        dreamWallTableView.reloadData()
    }
    
    func setupView(){
        dreamWallTableView.separatorStyle = .none
        searchBar.tintColor = .primaryPurple
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        searchBar.delegate = self
    }
}




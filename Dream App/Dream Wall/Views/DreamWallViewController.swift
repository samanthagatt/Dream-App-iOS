//
//  DreamWallViewController.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/8/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit



class DreamWallViewController: UIViewController, UISearchBarDelegate, DreamViewModelContainable {
    @IBOutlet weak var dreamWallTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func newAlarmButtonTapped(_ sender: Any) {
        _ = tabBarController?.selectedIndex = 1
    }
    // MARK: - Properties -
    var dreamViewModel: DreamViewModel? {
        didSet {
            print(dreamViewModel ?? "No dream view model")
        }
    }
    var filteredDreams: [Dream] = []
    var isSearching = false
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()   
        setupView()
        hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadData()
        hideDreamLabel()
    }
    
    // MARK: - Subviews
    private let noDataView = UILabel().style(
        text: "No Dreams",
        font: .avenirNext(ofSize: 25, isBold: false),
        textColor: .lightGray,
        textAlignment: .center
    )
}

// MARK: - TableView -
extension DreamWallViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredDreams.count
        } else {
            return dreamViewModel?.dreamArray.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dreamCell", for: indexPath) as? DreamTableViewCell else { return UITableViewCell() }
        if isSearching {
            cell.dream = filteredDreams[indexPath.row]
        } else {
            cell.dream = dreamViewModel?.dreamArray[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        92
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isSearching {
                let dream = filteredDreams[indexPath.row]
                dreamViewModel?.deleteDream(id: dream.identifier)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                guard let dream = dreamViewModel?.dreamArray[indexPath.row] else { return }
                dreamViewModel?.deleteDream(id: dream.identifier)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}


// MARK: - Prepare for Segue -
extension DreamWallViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = dreamWallTableView.indexPathForSelectedRow{
            guard let detailVC = segue.destination as? EditAndReplayDreamViewController else { return }
            detailVC.dreamViewModel = dreamViewModel
            if isSearching {
                detailVC.dream = filteredDreams[indexPath.row]
            } else {
                detailVC.dream = dreamViewModel?.dreamArray[indexPath.row]
            }
        }
    }
}

// MARK: - SearchBar -
extension DreamWallViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            isSearching = false
            dreamWallTableView.reloadData()
        } else {
            isSearching = true
            filteredDreams = dreamViewModel?.dreamArray.filter {
                $0.title.lowercased().contains(searchBar.text?.lowercased() ?? "") ||
                    $0.description.lowercased().contains(searchBar.text?.lowercased() ?? "")
            } ?? []
            dreamWallTableView.reloadData()
        }
    }
}

// MARK: - Private Methods -
private extension DreamWallViewController {
    func reloadData() {
        dreamViewModel?.loadFromPersistence()
        dreamWallTableView.reloadData()
    }
    func setupView() {
        dreamWallTableView.separatorStyle = .none
        searchBar.tintColor = .primaryPurple
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        searchBar.delegate = self
        view.addSubviews(noDataView)
        constrainViews()
    }
    
    func constrainViews(){
        noDataView.constrainCenterX(to:view)
        noDataView.constrainCenterY(to:view)
    }
    
    func hideDreamLabel(){
        if dreamViewModel?.dreamArray.count == 0 {
            noDataView.isHidden = false
        } else {
            noDataView.isHidden = true
        }
    }
}




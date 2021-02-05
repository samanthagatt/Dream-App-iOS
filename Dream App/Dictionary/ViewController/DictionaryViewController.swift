//
//  DictionaryViewController.swift
//  Dream Studio
//
//  Created by Perez Willie-Nwobu on 2/3/21.
//  Copyright © 2021 Samantha Gatt. All rights reserved.
//

import UIKit
import Firebase

class DictionaryViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var dictionaryTableView: UITableView!
    
    // MARK: - Properties -
    var docRef : DocumentReference!
    var filteredDictionary: [String : Any] = [:]
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        callAPI()
    }
}

// MARK: - Private Methods -
private extension DictionaryViewController {
    func setupView(){
        dictionaryTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        dictionaryTableView.dataSource = self
        dictionaryTableView.delegate = self
        self.navigationController?.navigationBar.topItem?.title = "Dictionary"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        searchBar.delegate = self
    }
    
    func callAPI(){
        FirebaseApp.configure()
        
        docRef = Firestore.firestore().document("DreamStudio/Dictionary")
        docRef.getDocument { (documentSnapShot, error) in
            guard let docuSnapshot = documentSnapShot, documentSnapShot?.exists ?? false else { return }
            guard let dictionaryData = docuSnapshot.data() else { return }
            DictionaryViewModel.dictionary = dictionaryData
            self.dictionaryTableView.reloadData()
        }
        
        docRef = Firestore.firestore().document("DreamStudio/Featured")
        docRef.getDocument { (documentSnapShot, error) in
            guard let docuSnapshot = documentSnapShot, documentSnapShot?.exists ?? false else { return }
            guard let dictionaryData = docuSnapshot.data() else { return }
            DictionaryViewModel.commonDreams = dictionaryData
            self.dictionaryTableView.reloadData()
        }
    }
}

// MARK: - TableView -
extension DictionaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredDictionary.count
        } else {
            return DictionaryViewModel.commonDreams.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dictionaryCell", for: indexPath) as? DictionaryTableViewCell else { return UITableViewCell() }
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        cell.selectedBackgroundView = backgroundView
        
        if isSearching {
            let text = Array(filteredDictionary.keys)[indexPath.row]
            let value = Array(filteredDictionary.values)[indexPath.row]
            cell.wordTitle.text = text
            cell.wordMeaning.text = value as? String
        } else {
            let text = Array(DictionaryViewModel.commonDreams.keys)[indexPath.row]
                       let value = Array(DictionaryViewModel.commonDreams.values)[indexPath.row]
                       cell.wordTitle.text = text
                       cell.wordMeaning.text = value as? String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        142
    }
    
}

// MARK: - SearchBar -
extension DictionaryViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            isSearching = false
            dictionaryTableView.reloadData()
        } else {
            isSearching = true
            
            filteredDictionary = DictionaryViewModel.dictionary.filter {
                $0.key.lowercased().contains(searchBar.text?.lowercased() ?? "")
            }
            dictionaryTableView.reloadData()
        }
    }
}

// MARK: - Prepare for Segue -
extension DictionaryViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = dictionaryTableView.indexPathForSelectedRow{
            guard let detailVC = segue.destination as? DictionaryDetailViewController else { return }
            if isSearching {
                 let text = Array(filteredDictionary.keys)[indexPath.row]
                           let value = Array(filteredDictionary.values)[indexPath.row]
                let dictionary = DreamDictionary(title: text, meaning: value as? String ?? "")
                detailVC.dictionary = dictionary
            } else {
                let text = Array(DictionaryViewModel.commonDreams.keys)[indexPath.row]
                             let value = Array(DictionaryViewModel.commonDreams.values)[indexPath.row]
                             let dictionary = DreamDictionary(title: text, meaning: value as? String ?? "")
                             detailVC.dictionary = dictionary
            }
        }
    }
}

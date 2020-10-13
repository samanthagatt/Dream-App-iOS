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

extension DreamWallViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DreamViewModel.shared.dreamArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dreamCell", for: indexPath) as? DreamTableViewCell else { return UITableViewCell() }
        cell.dream = DreamViewModel.shared.dreamArray[indexPath.row];        return cell
    }
}




//
//  AlarmViewController.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/5/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {

    @IBOutlet weak var alarmTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Alarm"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        alarmTableView.separatorStyle = .none
    }
    
    @IBAction func newAlarmButtonTapped(_ sender: Any) {
        
    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmcell", for: indexPath) as? AlarmTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        108
    }
    
}

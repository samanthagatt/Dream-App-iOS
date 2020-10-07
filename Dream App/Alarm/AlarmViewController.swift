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
        let vc = SetAlarmViewController()
        vc.modalTransitionStyle   = .crossDissolve;
        vc.modalPresentationStyle = .overCurrentContext
        vc.completion = { date, identifier in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                self.alarmTableView.reloadData()
                AlarmNotofications.shared.sendNotification(with: date, id: identifier)
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmcell", for: indexPath) as? AlarmTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.alarm = alarmArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = alarmArray[indexPath.row]
            AlarmNotofications.shared.removeNotification(with: alarm.identifier)
            //objects.remove(at: indexPath.row)
            alarmArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            alarmTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        108
    }
    
}

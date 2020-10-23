//
//  AlarmViewController.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/5/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var alarmTableView: UITableView!
    @IBAction func newAlarmButtonTapped(_ sender: Any) {
        let vc = SetAlarmViewController()
        vc.modalTransitionStyle   = .crossDissolve;
        vc.modalPresentationStyle = .overCurrentContext
        vc.completion = { date, identifier in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                self.hideAlarmLabel()
                AlarmNotofications.shared.sendNotification(with: date, id: identifier)
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Properties
    private let noDataView = UILabel().style(
        text: "No Alarms",
        font: .avenirNext(ofSize: 25, isBold: false),
        textColor: .lightGray,
        textAlignment: .center
    )
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Alarm"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        alarmTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupView()
        hideAlarmLabel()
    }
}

// MARK: - TableView
extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmViewModel.shared.alarmArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmcell", for: indexPath) as? AlarmTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.alarm = AlarmViewModel.shared.alarmArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmViewModel.shared.alarmArray[indexPath.row]
            AlarmNotofications.shared.removeNotification(with: alarm.identifier)
            AlarmViewModel.shared.deleteAlarm(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
            hideAlarmLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        95
    }
}

// MARK: - Private func
private extension AlarmViewController {
    func setupView(){
        AlarmViewModel.shared.loadFromPersistence()
        view.addSubviews(noDataView)
        constrainViews()
    }
    
    func constrainViews(){
        noDataView.constrainCenterX(to:view)
        noDataView.constrainCenterY(to:view)
    }
    
    func hideAlarmLabel(){
        alarmTableView.reloadData()
        if AlarmViewModel.shared.alarmArray.count == 0 {
            noDataView.isHidden = false
        } else {
            noDataView.isHidden = true
        }
    }
}

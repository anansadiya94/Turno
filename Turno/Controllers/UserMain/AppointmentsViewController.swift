//
//  AppointmentsViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class AppointmentsViewController: GenericTableView<AppointmentsListDescriptive> {
    
    // MARK: - Properties
    override var navBarTitle: String {
        return LocalizedConstants.my_turns_key.localized
    }
    
    var presenterAppointments: PresenterAppointments!
    @UseAutoLayout var genericView = GenericView()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(genericView)
        setGenericViewConstraints()
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenterAppointments.fetchData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        print("TAPPED")
    }
    
    // MARK: - GenericTableView methods
    init() {
        super.init(nibName: nil, bundle: nil)
        super.configureTableView(tableView: genericView.tableView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.configureTableView(tableView: genericView.tableView)
    }

    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenterAppointments.fetchData()
    }
    
    // MARK: - Private methods
    private func setGenericViewConstraints() {
        NSLayoutConstraint.activate([
            genericView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            genericView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
            genericView.leftAnchor.constraint(equalTo: view.leftAnchor),
            genericView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(cancelTappedAction(_:)),
                                               name: Appointments.cancelTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callNowTappedAction(_:)),
                                               name: Appointments.callNowTapped, object: nil)
    }
    
    // MARK: - UI interaction methods
    @objc func cancelTappedAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let identifier = dict["identifier"] as? String {
                presenterAppointments.cancelTapped(turnId: identifier)
            }
        }
    }
    
    @objc func callNowTappedAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let phone = dict["phone"] as? String {
                presenterAppointments.callNowTapped(phone: phone)
            }
        }
    }
}

// MARK: - PresenterAppointments methods
extension AppointmentsViewController: PresenterAppointmentsView {
    func didSetData(model: AppointmentsListDescriptive) {
        self.source = model
        genericView.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func showEmptyMessage(title: String, message: String) {
        self.genericView.tableView.emptyMessage(title: title, message: message)
    }
    
    func removeEmptyMessage() {
        self.genericView.tableView.removeEmptyMessage()
    }
    
    func startWaitingView() {
        startWaiting()
    }
    
    func stopWaitingView() {
        stopWaiting()
    }
    
    func showPopupView(withTitle title: String?, withText text: String?, withButton button: String?, button2: String?, completion: ((Bool?, Bool?) -> Void)?) {
        showPopup(withTitle: title, withText: text, withButton: button, button2: button2, completion: completion)
    }
    
    func call(_ number: String) {
        self.callNumber(number)
    }
}

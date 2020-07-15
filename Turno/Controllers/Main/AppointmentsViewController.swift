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
    
    // MARK: - GenericTableView methods
    init() {
        super.init(nibName: nil, bundle: nil)
        super.configureTableView(tableView: genericView.tableView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.configureTableView(tableView: genericView.tableView)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 216
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenterAppointments.fetchData()
    }
    
    // MARK: - Private methods
    private func setGenericViewConstraints() {
        NSLayoutConstraint.activate([
            genericView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            genericView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
            if let identifier = dict["identifier"] as? String {
                presenterAppointments.callNowTapped(turnId: identifier)
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
    
    func startWaitingView() {
        startWaiting()
    }
    
    func stopWaitingView() {
        stopWaiting()
    }
    
    func showPopupView(withTitle title: String?, withText text: String?, withButton button: String?, button2: String?, completion: ((Bool?, Bool?) -> Void)?) {
        showPopup(withTitle: title, withText: text, withButton: button, button2: button2, completion: completion)
    }
}

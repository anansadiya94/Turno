//
//  CheckAvailabilityViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 06/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class CheckAvailabilityViewController: ParentViewController {
    
    // MARK: - Properties
    var presenterCheckAvailability: PresenterCheckAvailability!
    @UseAutoLayout var checkAvailabilityView = CheckAvailabilityView()
    
    var model: ModelBusiness?
    var services: [Service]?
    var turns: [Turn]?
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setCheckAvailabilityViewConstraints()
        setTableView()
    }
    
    // MARK: - Private methods
    private func setCheckAvailabilityViewConstraints() {
        self.view.addSubview(checkAvailabilityView)
        NSLayoutConstraint.activate([
            checkAvailabilityView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            checkAvailabilityView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            checkAvailabilityView.leftAnchor.constraint(equalTo: view.leftAnchor),
            checkAvailabilityView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setTableView() {
        checkAvailabilityView.tableView.register(UINib(nibName: kServiceTableViewCellNib, bundle: nil),
                                        forCellReuseIdentifier: kServiceCellID)
        checkAvailabilityView.tableView.register(UINib(nibName: kBusinessAppointmentTableViewCellNib, bundle: nil),
                                        forCellReuseIdentifier: kBusinessAppoitmentCellID)
        checkAvailabilityView.tableView.register(UINib(nibName: kInformationTableViewCellNib, bundle: nil),
                                        forCellReuseIdentifier: kinformationCellID)
    }
}

extension CheckAvailabilityViewController: PresenterCheckAvailabilityView {
    func didSetData(name: String?, modelCheckTurnsAvailability: ModelCheckTurnsAvailability) {
        DispatchQueue.main.async {
            self.navigationItem.title = name
        }
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

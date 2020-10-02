//
//  ConfirmationViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 23/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class ConfirmationViewController: ParentViewController {
    
    // MARK: - Properties
    var presenterConfirmation: PresenterConfirmation!
    @UseAutoLayout var confirmationView = ConfirmationView()
    
    var bookedServices: [Service]?
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfirmationViewConstraints()
        addTarget()
        setTableView()
    }
    
    // MARK: - Private methods
    private func setConfirmationViewConstraints() {
        self.view.addSubview(confirmationView)
        NSLayoutConstraint.activate([
            confirmationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            confirmationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            confirmationView.leftAnchor.constraint(equalTo: view.leftAnchor),
            confirmationView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func addTarget() {
        confirmationView.confitmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmationView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        confirmationView.blockButton.addTarget(self, action: #selector(blockButtonTapped), for: .touchUpInside)
    }
    
    private func setTableView() {
        confirmationView.tableView.dataSource = self
        confirmationView.tableView.register(UINib(nibName: kServiceTableViewCellNib, bundle: nil),
                                            forCellReuseIdentifier: kServiceCellID)
    }

    // MARK: - UI interaction methods
    @objc func confirmButtonTapped() {
        presenterConfirmation.confirmButtonTapped()
    }
    
    @objc func cancelButtonTapped() {
        presenterConfirmation.cancelButtonTapped()
    }
    
    @objc func blockButtonTapped() {
        presenterConfirmation.blockButtonTapped()
    }
}

// MARK: - PresenterConfirmationView methods
extension ConfirmationViewController: PresenterConfirmationView {
    func didSetData(name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?,
                    confirmationViewType: ConfirmationViewType?) {
        self.bookedServices = bookedServices
        DispatchQueue.main.async {
            self.navigationItem.title = name
            let day = bookedSlot?.slot?.toDisplayableDate(type: .date)
            let startTime = bookedSlot?.slot?.toDisplayableDate(type: .hour)
            let bookedServicesDuration = ServiceTimeCalculation.calculateDuration(to: bookedServices)
            let endTimeDate = bookedSlot?.slot?.calculateEndDate(adding: bookedServicesDuration)
            let endTime = endTimeDate?.toDisplayableDate(type: .hour)
            self.confirmationView.setHeaderStackViewData(day: day,
                                                         startTime: startTime,
                                                         endTime: endTime)
            self.confirmationView.setViewType(to: confirmationViewType)
            self.confirmationView.tableView.reloadData()
        }
    }
    
    func popToBusinessViewController(animated: Bool) {
        if let viewControllers = self.navigationController?.viewControllers {
            viewControllers.forEach({viewController in
                if viewController.isKind(of: BusinessViewController.self) {
                    _ =  self.navigationController?.popToViewController(viewController, animated: animated)
                }
            })
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

// MARK: - UITableViewDataSource methods
extension ConfirmationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookedServices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = confirmationView.tableView.dequeueReusableCell(withIdentifier: kServiceCellID, for: indexPath) as? ServiceTableViewCell,
            let service = bookedServices?[indexPath.row] {
            cell.config(service: service, type: .booked)
            return cell
        }
        return UITableViewCell()
    }
}

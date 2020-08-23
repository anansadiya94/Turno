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
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfirmationViewConstraints()
        addTarget()
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
    }
    
    private func calculateDuration(to bookedServices: [Service]?) -> Int {
        var duration = 0
        guard let bookedServices = bookedServices else {
            return duration
        }
        bookedServices.forEach({
            if let count = $0.count, let durationInMinutes = $0.durationInMinutes {
                duration += (count * durationInMinutes)
            }
        })
        return duration
    }
    
    // MARK: - UI interaction methods
    @objc func confirmButtonTapped() {
        presenterConfirmation.confirmButtonTapped()
    }
}

// MARK: - PresenterConfirmationView methods
extension ConfirmationViewController: PresenterConfirmationView {
    func didSetData(name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?) {
        DispatchQueue.main.async {
            self.navigationItem.title = name
            let day = bookedSlot?.slot?.toDisplayableDate(type: .date)
            let startTime = bookedSlot?.slot?.toDisplayableDate(type: .hour)
            let bookedServicesDuration = self.calculateDuration(to: bookedServices)
            let endTimeDate = bookedSlot?.slot?.calculateEndDate(adding: bookedServicesDuration)
            let endTime = endTimeDate?.toDisplayableDate(type: .hour)
            self.confirmationView.setHeaderStackViewData(day: day,
                                                         startTime: startTime,
                                                         endTime: endTime)
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

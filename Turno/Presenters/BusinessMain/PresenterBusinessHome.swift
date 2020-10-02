//
//  PresenterBusinessHome.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterBusinessHomeView: class {
    func didSetData(turns: [Turn])
}

class PresenterBusinessHome {
    
    // MARK: - Properties
    private weak var view: PresenterBusinessHomeView?
    var delegate: SelectButtonBusiness!
    
    // TODO: Delete after remote call
    var turns = [
        Turn(identifier: "dummy1", dateTimeUTC: "2020-09-30T09:00:00", services: [
            Service(identifier: "1", serviceName: "Test1", durationInMinutes: 10, count: 1),
            Service(identifier: "2", serviceName: "Test2", durationInMinutes: 20, count: 2),
            Service(identifier: "3", serviceName: "Test3", durationInMinutes: 30, count: 3),
            Service(identifier: "4", serviceName: "Test4", durationInMinutes: 10, count: 4)
        ]),
        Turn(identifier: "dummy2", dateTimeUTC: "2020-09-30T16:00:00", services: [
            Service(identifier: "1", serviceName: "Test11", durationInMinutes: 10, count: 3)
        ]),
        Turn(identifier: "dummy3", dateTimeUTC: "2020-10-1T09:00:00", services: [
            Service(identifier: "1", serviceName: "Test111", durationInMinutes: 10, count: 1),
            Service(identifier: "2", serviceName: "Test222", durationInMinutes: 20, count: 2)
        ]),
        Turn(identifier: "dummy4", dateTimeUTC: "2020-10-2T09:00:00", services: [
            Service(identifier: "1", serviceName: "Test1111", durationInMinutes: 10, count: 1),
            Service(identifier: "2", serviceName: "Test2222", durationInMinutes: 20, count: 2),
            Service(identifier: "3", serviceName: "Test3333", durationInMinutes: 30, count: 3)
        ])
    ]
    
    // MARK: - init Methods
    init(view: PresenterBusinessHomeView, delegate: SelectButtonBusiness) {
        self.view = view
        self.delegate = delegate
        self.notifyView()
    }

    private func notifyView() {
        view?.didSetData(turns: turns)
    }
    
    func addAppointmentTapped() {
        delegate.addAppointmentTapped()
    }
    
    func showAppointmentTapped(turn: Turn) {
        delegate.showAppointmentTapped(turn: turn)
    }
}

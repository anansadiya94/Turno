//
//  PresenterCheckAvailability.swift
//  Turno
//
//  Created by Anan Sadiya on 06/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterCheckAvailabilityView: PresenterParentView {
    func didSetData(name: String?, modelCheckTurnsAvailability: ModelCheckTurnsAvailability, totalServicesTime: String)
}

class PresenterCheckAvailability {
    
    // MARK: - Properties
    private weak var view: PresenterCheckAvailabilityView?
    var delegate: SelectButtonEntity!
    var identifier: String?
    var name: String?
    var bookedServices: [Service]?
    let networkManager = NetworkManager()
    var modelCheckTurnsAvailability: ModelCheckTurnsAvailability?
    
    // MARK: - init Methods
    init(view: PresenterCheckAvailabilityView, delegate: SelectButtonEntity, identifier: String?, name: String?, bookedServices: [Service]?, modelCheckTurnsAvailability: ModelCheckTurnsAvailability?) {
        self.view = view
        self.delegate = delegate
        self.identifier = identifier
        self.name = name
        self.bookedServices = bookedServices
        self.modelCheckTurnsAvailability = modelCheckTurnsAvailability
        self.notifyView()
    }
    
    // MARK: - Private methods
    private func notifyView() {
        let minutesToHoursMinutes = ServiceMinutesToHoursMinutes.minutesToHoursMinutes(bookedServices: bookedServices)
        guard let modelCheckTurnsAvailability = modelCheckTurnsAvailability else { return }
        view?.didSetData(name: name, modelCheckTurnsAvailability: modelCheckTurnsAvailability,
                         totalServicesTime: "\(minutesToHoursMinutes.hours)h \(minutesToHoursMinutes.leftMinutes)m")
    }
    
    // MARK: - Public Interface
    func bookNowButtonTapped(bookedSlot: EmptySlot?) {
        delegate.didSelectConfirm(identifier: identifier, name: name, bookedServices: bookedServices, bookedSlot: bookedSlot)
    }
}

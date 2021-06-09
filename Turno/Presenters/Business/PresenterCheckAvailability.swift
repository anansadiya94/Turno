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
    private var networkManager: NetworkManagerProtocol
    private weak var userDelegate: SelectButtonEntity?
    private weak var businessDelegate: SelectButtonBusiness?
    var identifier: String?
    var name: String?
    var bookedServices: [Service]?
    var modelCheckTurnsAvailability: ModelCheckTurnsAvailability?
    var customer: Customer?
    
    // MARK: - init Methods
    init(view: PresenterCheckAvailabilityView, networkManager: NetworkManagerProtocol, delegate: SelectButtonEntity, identifier: String?, name: String?, bookedServices: [Service]?, modelCheckTurnsAvailability: ModelCheckTurnsAvailability?) {
        self.view = view
        self.networkManager = networkManager
        self.userDelegate = delegate
        self.identifier = identifier
        self.name = name
        self.bookedServices = bookedServices
        self.modelCheckTurnsAvailability = modelCheckTurnsAvailability
        self.notifyView()
    }
    
    init(view: PresenterCheckAvailabilityView, networkManager: NetworkManagerProtocol, delegate: SelectButtonBusiness, identifier: String?, name: String?, bookedServices: [Service]?, modelCheckTurnsAvailability: ModelCheckTurnsAvailability?, customer: Customer?) {
        self.view = view
        self.networkManager = networkManager
        self.businessDelegate = delegate
        self.identifier = identifier
        self.name = name
        self.bookedServices = bookedServices
        self.modelCheckTurnsAvailability = modelCheckTurnsAvailability
        self.customer = customer
        self.notifyView()
    }
    
    // MARK: - Private methods
    private func notifyView() {
        let minutesToHoursMinutes = ServiceTimeCalculation.minutesToHoursMinutes(bookedServices: bookedServices)
        guard let modelCheckTurnsAvailability = modelCheckTurnsAvailability else { return }
        view?.didSetData(name: name, modelCheckTurnsAvailability: modelCheckTurnsAvailability,
                         totalServicesTime:
                            "\(minutesToHoursMinutes.hours)" +
                            LocalizedConstants.hour_key.localized +
                            " " +
                            "\(minutesToHoursMinutes.leftMinutes)" +
                            LocalizedConstants.minute_key.localized)
    }
    
    // MARK: - Public Interface
    func bookNowButtonTapped(bookedSlot: EmptySlot?) {
        if let userDelegate = userDelegate {
            userDelegate.didSelectConfirm(identifier: identifier,
                                          name: name,
                                          bookedServices: bookedServices,
                                          bookedSlot: bookedSlot)
        }
        if let businessDelegate = businessDelegate {
            businessDelegate.didSelectConfirm(identifier: identifier,
                                              name: name,
                                              bookedServices: bookedServices,
                                              bookedSlot: bookedSlot,
                                              customer: customer)
        }
    }
}

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
    var modelCheckTurnsAvailability = ModelCheckTurnsAvailability()
    
    // MARK: - init Methods
    init(view: PresenterCheckAvailabilityView, delegate: SelectButtonEntity, identifier: String?, name: String?, bookedServices: [Service]?) {
        self.view = view
        self.delegate = delegate
        self.identifier = identifier
        self.name = name
        self.bookedServices = bookedServices
        self.fetchData()
    }
    
    // MARK: - Private methods
    func fetchData() {
        self.view?.startWaitingView()
        let modelCheckTurnsAvailabilityTask = ModelCheckTurnsAvailabilityTask(services: [])
        networkManager.checkTurnsAvailability(modelTask: modelCheckTurnsAvailabilityTask) { (modelCheckTurnsAvailability, error) in
            if error as? MoyaError != nil {
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                         completion: nil)
                return
            }
            if let error = error as? AppError {
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                         completion: nil)
                return
            }
            if let modelCheckTurnsAvailability = modelCheckTurnsAvailability {
                self.view?.stopWaitingView()
                self.modelCheckTurnsAvailability = modelCheckTurnsAvailability
                self.notifyView()
            }
        }
    }
    
    private func notifyView() {
        let minutesToHoursMinutes = ServiceMinutesToHoursMinutes.minutesToHoursMinutes(bookedServices: bookedServices)
        view?.didSetData(name: name, modelCheckTurnsAvailability: modelCheckTurnsAvailability,
                         totalServicesTime: "\(minutesToHoursMinutes.hours)h \(minutesToHoursMinutes.leftMinutes)m")
    }
    
    // MARK: - Public Interface
    func bookNowButtonTapped(bookedSlot: EmptySlot?) {
        bookedSlot?.services = bookedServices
        //TODO: Call API
    }
}

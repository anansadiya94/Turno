//
//  PresenterAddAppointment.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterAddAppointmentView: PresenterParentView {
    func showNameTextFieldLabel(type: TextFieldErrorType)
    func showPhoneNumberTextFieldLabel(type: TextFieldErrorType)
    func showAlert()
    func modifyModel(identifier: String, count: Int)
    func appointmentConfirmed(bookedTurn: Turn)
}

class PresenterAddAppointment {
    
    // MARK: - Properties
    private weak var view: PresenterAddAppointmentView?
    var delegate: SelectButtonBusiness!
    let networkManager = NetworkManager()
    
    // MARK: - init Methods
    init(view: PresenterAddAppointmentView, delegate: SelectButtonBusiness) {
        self.view = view
        self.delegate = delegate
    }
    
    // MARK: - Private methods
    private func notifyView(model: ModelBusiness) {
//        view?.didSetData(model: model)
    }
    
    // MARK: - Public Interface
    func modifyModel(identifier: String, count: Int) {
        view?.modifyModel(identifier: identifier, count: count)
    }
    
    func checkAvailabilityButtonTapped(identifier: String?, bookedServices: [Service]?) {
        self.view?.startWaitingView()
        let modelCheckTurnsAvailabilityTask = ModelCheckTurnsAvailabilityTask(services: [])
        networkManager.getAvailableTimes(modelTask: modelCheckTurnsAvailabilityTask) { (modelCheckTurnsAvailability, error) in
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
            if let modelCheckTurnsAvailability = modelCheckTurnsAvailability,
                let isAvailableDatesEmpty = modelCheckTurnsAvailability.availableDates?.isEmpty,
                !isAvailableDatesEmpty {
                self.view?.stopWaitingView()
//                self.delegate.didSelectCheckAvailability(identifier: identifier, name: self.model?.name,
//                                                         bookedServices: bookedServices,
//                                                         modelCheckTurnsAvailability: modelCheckTurnsAvailability)
            } else {
                self.view?.stopWaitingView()
                // TODO: Translate
                self.view?.showPopupView(withTitle: "No available dates",
                                         withText: "Sorry! We couldn’t find any availabel date. Check for less services or try again later on.",
                                         withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                         completion: nil)
            }
        }
    }

    func appointmentConfirmed(bookedTurn: Turn) {
        view?.appointmentConfirmed(bookedTurn: bookedTurn)
    }
}

//
//  PresenterBusiness.swift
//  Turno
//
//  Created by Anan Sadiya on 18/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterBusinessView: PresenterParentView {
    func didSetData(model: ModelBusiness)
    func modifyModel(identifier: String, count: Int)
    func openMap(model: ModelLocation)
    func send(email: String)
    func call(_ number: String)
    func appointmentConfirmed(bookedTurn: Turn)
}

class PresenterBusiness {
    
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    private weak var view: PresenterBusinessView?
    private weak var delegate: SelectButtonEntity?
    var model: ModelBusiness?
    
    // MARK: - init Methods
    init(view: PresenterBusinessView,
         networkManager: NetworkManagerProtocol,
         analyticsManager: AnalyticsManagerProtocol,
         delegate: SelectButtonEntity,
         model: ModelBusiness) {
        self.view = view
        self.networkManager = networkManager
        self.analyticsManager = analyticsManager
        self.delegate = delegate
        self.model = model
        self.notifyView(model: model)
    }
    
    // MARK: - Private methods
    private func notifyView(model: ModelBusiness) {
        view?.didSetData(model: model)
    }
    
    private func cancelTurnConfirmed(turnId: String) {
        self.view?.startWaitingView()
        let modelCancelTurnTask: ModelCancelTurnTask = ModelCancelTurnTask(turnId: turnId)
        networkManager.cancelTurn(modelTask: modelCancelTurnTask) { _, error in
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
            self.view?.stopWaitingView()
            let filteredTurns = self.model?.turns?.filter({$0.identifier != turnId})
            self.model?.turns = filteredTurns
            if let model = self.model {
                self.notifyView(model: model)
            }
        }
    }
    
    // MARK: - Public Interface
    func modifyModel(identifier: String, count: Int) {
        view?.modifyModel(identifier: identifier, count: count)
    }
    
    func checkAvailabilityButtonTapped(identifier: String?, bookedServices: [Service]?) {
        self.view?.startWaitingView()
        var servicesToBook: [ServiceToBook] = []
        bookedServices?.forEach({ servicesToBook.append(ServiceToBook(identifier: $0.identifier,
                                                                      count: $0.count)) })
        let modelCheckTurnsAvailabilityTask = ModelCheckTurnsAvailabilityTask(servicesToBook: servicesToBook)
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
                self.delegate?.didSelectCheckAvailability(identifier: identifier, name: self.model?.name,
                                                         bookedServices: bookedServices,
                                                         modelCheckTurnsAvailability: modelCheckTurnsAvailability)
            } else {
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.no_available_dates_title_key.localized,
                                         withText: LocalizedConstants.no_available_dates_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                         completion: nil)
            }
        }
    }
    
    func openMaps(model: ModelLocation) {
        view?.openMap(model: model)
    }
    
    func send(email: String) {
        view?.send(email: email)
    }
    
    func call(_ number: String) {
        view?.call(number)
    }
    
    func cancelTapped(turnId: String) {
        self.view?.showPopupView(withTitle: LocalizedConstants.cancel_turn_title_key.localized,
                                 withText: LocalizedConstants.cancel_turn_message_key.localized,
                                 withButton: LocalizedConstants.no_key.localized,
                                 button2: LocalizedConstants.yes_key.localized,
                                 completion: { (_, yes) in
                                    if yes == true {
                                        self.cancelTurnConfirmed(turnId: turnId)
                                    }
        })
    }
    
    func appointmentConfirmed(bookedTurn: Turn) {
        view?.appointmentConfirmed(bookedTurn: bookedTurn)
    }
}

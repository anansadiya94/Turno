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

enum InformationRowType: String {
    case location = "Location"
    case mail = "Mail"
    case phoneNumber = "Phone number"
}

class PresenterBusiness {
    
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    private weak var view: PresenterBusinessView?
    private weak var delegate: SelectButtonEntity?
    var model: ModelBusiness?
    
    private struct Constants {
        static let screenName = "Business Screen"
        static let checkAvailabilityAnalyticValue = LocalizedConstants.check_availability_key.enLocalized
        static let cancelTurnAnalyticValue = LocalizedConstants.cancel_turn_key.enLocalized
        static let noAnalyticValue = LocalizedConstants.no_key.enLocalized
        static let yesAnalyticValue = LocalizedConstants.yes_key.enLocalized
        static let noAvailableDatesTitleAnalyticValue = LocalizedConstants.no_available_dates_title_key.enLocalized
        static let noAvailableDatesMessageAnalyticValue = LocalizedConstants.no_available_dates_message_key.enLocalized
    }
    
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
        view?.startWaitingView()
        let modelCancelTurnTask: ModelCancelTurnTask = ModelCancelTurnTask(turnId: turnId)
        networkManager.cancelTurn(modelTask: modelCancelTurnTask) { _, error in
            if error as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                         completion: nil)
                return
            }
            if let error = error as? AppError {
                self.analyticsManager.trackAlert(alertTitle: error.title,
                                                 alertMessage: error.message,
                                                 screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                         completion: nil)
                return
            }
            self.fetchBusiness()
//            self.view?.stopWaitingView()
//            let filteredTurns = self.model?.turns?.filter({$0.identifier != turnId})
//            self.model?.turns = filteredTurns
//            if let model = self.model {
//                self.notifyView(model: model)
//            }
        }
    }
    
    private func fetchBusiness() {
        let modelBusinessTask = ModelBusinessTask(query: "")
        networkManager.getBusinesses(modelTask: modelBusinessTask) { [weak self] modelList, error in
            guard let self = self else { return }
            if error as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil) { _, _ in
                }
                return
            }
            if let error = error as? AppError {
                self.analyticsManager.trackAlert(alertTitle: error.title,
                                                 alertMessage: error.message,
                                                 screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil) { _, _ in
                }
                return
            }
            if let modelList = modelList {
                self.view?.stopWaitingView()
                let businessModel = modelList.first(where: { $0.identifier == self.model?.identifier ?? "" })
                if let businessModel = businessModel {
                    self.model = businessModel
                    self.notifyView(model: businessModel)
                }
            }
        }
    }
    
    // MARK: - Public Interface
    func trackScreen() {
        analyticsManager.track(eventKey: .businessScreenSeen, withProperties: nil)
    }
    
    func trackTopNavigationTabTap(previousTabName: String, currentTabName: String) {
        analyticsManager.track(eventKey: .topNavigationTabTap, withProperties: [
            .previousTabName: previousTabName,
            .currentTabName: currentTabName
        ])
    }
    
    func modifyModel(identifier: String, count: Int) {
        view?.modifyModel(identifier: identifier, count: count)
    }
    
    // MARK: - UI interaction methods
    func checkAvailabilityButtonTapped(identifier: String?, bookedServices: [Service]?) {
        trackCheckAvailabilityButtonTapped(businessIdentifier: model?.identifier, bookedServices: bookedServices)
        view?.startWaitingView()
        var servicesToBook: [ServiceToBook] = []
        bookedServices?.forEach({ servicesToBook.append(ServiceToBook(identifier: $0.identifier,
                                                                      count: $0.count)) })
        let modelCheckTurnsAvailabilityTask = ModelCheckTurnsAvailabilityTask(servicesToBook: servicesToBook)
        networkManager.getAvailableTimes(modelTask: modelCheckTurnsAvailabilityTask) { [weak self] modelCheckTurnsAvailability, error in
            guard let self = self else { return }
            if error as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            if let error = error as? AppError {
                self.analyticsManager.trackAlert(alertTitle: error.title,
                                                 alertMessage: error.message,
                                                 screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
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
                self.analyticsManager.trackAlert(alertTitle: Constants.noAvailableDatesTitleAnalyticValue,
                                                 alertMessage: Constants.noAvailableDatesMessageAnalyticValue,
                                                 screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.no_available_dates_title_key.localized,
                                         withText: LocalizedConstants.no_available_dates_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
                                         completion: nil)
            }
        }
    }
    
    func openMaps(model: ModelLocation) {
        trackInformationTapped(informationRowType: .location, informationRowText: String(describing: model.location))
        view?.openMap(model: model)
    }
    
    func send(email: String) {
        trackInformationTapped(informationRowType: .mail, informationRowText: email)
        view?.send(email: email)
    }
    
    func call(_ number: String) {
        trackInformationTapped(informationRowType: .phoneNumber, informationRowText: number)
        view?.call(number)
    }
    
    func cancelTapped(turnId: String) {
        analyticsManager.track(eventKey: .buttonTapped, withProperties: [
            .buttonText: Constants.cancelTurnAnalyticValue,
            .screenName: Constants.screenName,
            .turnIdentifier: turnId
        ])
        view?.showPopupView(withTitle: LocalizedConstants.cancel_turn_title_key.localized,
                            withText: LocalizedConstants.cancel_turn_message_key.localized,
                            withButton: LocalizedConstants.no_key.localized,
                            button2: LocalizedConstants.yes_key.localized,
                            completion: { [weak self] no, yes in
                                guard let self = self else { return }
                                if no == true {
                                    self.analyticsManager.track(eventKey: .alertActionTapped, withProperties: [
                                        .actionText: Constants.noAnalyticValue,
                                        .screenName: Constants.screenName
                                    ])
                                }
                                if yes == true {
                                    self.analyticsManager.track(eventKey: .alertActionTapped, withProperties: [
                                        .actionText: Constants.yesAnalyticValue,
                                        .screenName: Constants.screenName
                                    ])
                                    self.cancelTurnConfirmed(turnId: turnId)
                                }
                            })
    }
    
    func appointmentConfirmed(bookedTurn: Turn) {
        view?.appointmentConfirmed(bookedTurn: bookedTurn)
    }
}

private extension PresenterBusiness {
    func trackCheckAvailabilityButtonTapped(businessIdentifier: String?, bookedServices: [Service]?) {
        analyticsManager.track(eventKey: .buttonTapped, withProperties: [
            .buttonText: Constants.checkAvailabilityAnalyticValue,
            .screenName: Constants.screenName,
            .businessIdentifier: businessIdentifier ?? "",
            .totalOfServices: String(bookedServices?.count ?? 0),
            .totalOfServicesTime: String(ServiceTimeCalculation.calculateDuration(to: bookedServices))
        ])
    }
    
    func trackInformationTapped(informationRowType: InformationRowType, informationRowText: String?) {
        analyticsManager.track(eventKey: .informationTapped, withProperties: [
            .informationRowType: informationRowType.rawValue,
            .informationRowText: informationRowText ?? "",
            .screenName: Constants.screenName
        ])
    }
}

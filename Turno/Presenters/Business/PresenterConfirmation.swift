//
//  PresenterConfirmation.swift
//  Turno
//
//  Created by Anan Sadiya on 23/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterConfirmationView: PresenterParentView {
    func didSetData(name: String?, bookedServices: [Service]?,
                    bookedSlot: EmptySlot?, confirmationViewType: ConfirmationViewType?)
    func popToBusinessViewController(animated: Bool)
    func popToBusinessHomeViewController(animated: Bool)
    func call(_ number: String)
}

class PresenterConfirmation {
    
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    private weak var view: PresenterConfirmationView?
    private weak var userDelegate: SelectButtonEntity?
    private weak var businessDelegate: SelectButtonBusiness?
    var userId: String?
    var name: String?
    var turnId: String?
    var bookedServices: [Service]?
    var bookedSlot: EmptySlot?
    var confirmationViewType: ConfirmationViewType?
    var customer: Customer?
    
    var screenName: String {
        if userDelegate != nil {
            return "Turn Info Screen"
        }
        if businessDelegate != nil {
            return "Confirmation Screen"
        }
        return ""
    }
    
    var screenSeenKey: AnalyticsKeys {
        if userDelegate != nil {
            return .turnInfoScreenSeen
        }
        if businessDelegate != nil {
            return .confirmationScreenSeen
        }
        return .unknown
    }
    
    private struct Constants {
        static let confirmAnalyticValue = LocalizedConstants.confirm_key.enLocalized
        static let cancelTurnAnalyticValue = LocalizedConstants.cancel_turn_key.enLocalized
        static let callNowAnalyticValue = LocalizedConstants.call_now_key.enLocalized
        static let blockUserAnalyticValue = LocalizedConstants.block_user_key.enLocalized
        static let cancelAnalyticValue = LocalizedConstants.cancel_key.enLocalized
        static let noAnalyticValue = LocalizedConstants.no_key.enLocalized
        static let yesAnalyticValue = LocalizedConstants.yes_key.enLocalized
    }
    
    // MARK: - init Methods
    init(view: PresenterConfirmationView, networkManager: NetworkManagerProtocol, analyticsManager: AnalyticsManagerProtocol, delegate: SelectButtonEntity, userId: String?, name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?, confirmationViewType: ConfirmationViewType?) {
        self.view = view
        self.networkManager = networkManager
        self.analyticsManager = analyticsManager
        self.userDelegate = delegate
        self.userId = userId
        self.name = name
        self.bookedServices = bookedServices
        self.bookedSlot = bookedSlot
        self.confirmationViewType = confirmationViewType
        self.notifyView()
        self.trackScreen()
    }
    
    init(view: PresenterConfirmationView, networkManager: NetworkManagerProtocol, analyticsManager: AnalyticsManagerProtocol, delegate: SelectButtonBusiness, userId: String?, name: String?, turnId: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?,
         confirmationViewType: ConfirmationViewType?, customer: Customer?) {
        self.view = view
        self.networkManager = networkManager
        self.analyticsManager = analyticsManager
        self.businessDelegate = delegate
        self.userId = userId
        self.name = name
        self.turnId = turnId
        self.bookedServices = bookedServices
        self.bookedSlot = bookedSlot
        self.confirmationViewType = confirmationViewType
        self.customer = customer
        self.notifyView()
        self.trackScreen()
    }
    
    // MARK: - Private methods
    private func notifyView() {
        view?.didSetData(name: customer?.name,
                         bookedServices: bookedServices,
                         bookedSlot: bookedSlot,
                         confirmationViewType: confirmationViewType)
    }
    
    private func popToViewController() {
        if userDelegate != nil {
            self.view?.popToBusinessViewController(animated: true)
        }
        if businessDelegate != nil {
            self.view?.popToBusinessHomeViewController(animated: true)
        }
    }
    
    private func postBookedTurn(bookedTurn: Turn?) {
        if userDelegate != nil {
            if let bookedTurn = bookedTurn {
                let bookedTurnDict: [String: Turn] = ["bookedTurn": bookedTurn]
                NotificationCenter.default.post(name: Appointments.appointmentConfirmed,
                                                object: nil,
                                                userInfo: bookedTurnDict)
            }
        }
        if businessDelegate != nil {
            if var bookedTurn = bookedTurn {
                bookedTurn.userName = customer?.name
                bookedTurn.userPhone = customer?.phoneNumber
                let bookedTurnDict: [String: Turn] = ["bookedTurn": bookedTurn]
                NotificationCenter.default.post(name: Appointments.appointmentConfirmed,
                                                object: nil,
                                                userInfo: bookedTurnDict)
            }
        }
    }
    
    private func blockUserConfirmed() {
        self.view?.startWaitingView()
        let modelBlockUser = ModelBlockUser(userId: userId)
        networkManager.blockUser(modelBlockUser: modelBlockUser) { [weak self] _, error in
            guard let self = self else { return }
            if error as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: self.screenName)
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
                                                 screenName: self.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            self.popToViewController()
        }
    }
    
    private func cancelTurnConfirmed(turnId: String?) {
        self.view?.startWaitingView()
        guard let turnId = turnId else {
            self.view?.stopWaitingView()
            self.view?.showPopupView(withTitle: LocalizedConstants.generic_error_title_key.localized,
                                     withText: LocalizedConstants.generic_error_message_key.localized,
                                     withButton: LocalizedConstants.ok_key.localized,
                                     button2: nil,
                                     completion: nil)
            return
        }
        let modelCancelTurnTask: ModelCancelTurnTask = ModelCancelTurnTask(turnId: turnId)
        networkManager.cancelTurn(modelTask: modelCancelTurnTask) { [weak self] _, error in
            guard let self = self else { return }
            if error as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: self.screenName)
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
                                                 screenName: self.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            self.view?.stopWaitingView()
            self.popToViewController()
        }
    }
    
    private func bookByUser() {
        var servicesToBook: [ServiceToBook] = []
        bookedServices?.forEach({ servicesToBook.append(ServiceToBook(identifier: $0.identifier,
                                                                      count: $0.count)) })
        let modelBookTask = ModelBookTask(servicesToBook: servicesToBook,
                                          dateTime: bookedSlot?.slot?.toGlobalTimeString())
        networkManager.book(modelTask: modelBookTask) { [weak self] bookedTurn, error in
            guard let self = self else { return }
            if error as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: self.screenName)
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
                                                 screenName: self.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            self.view?.stopWaitingView()
            self.popToViewController()
            self.postBookedTurn(bookedTurn: bookedTurn)
        }
    }
    
    private func bookByBusiness() {
        var servicesToBook: [ServiceToBook] = []
        bookedServices?.forEach({ servicesToBook.append(ServiceToBook(identifier: $0.identifier,
                                                                      count: $0.count)) })
        let modelBookByBusinessTask = ModelBookByBusinessTask(servicesToBook: servicesToBook,
                                                              dateTime: bookedSlot?.slot?.toGlobalTimeString(),
                                                              phoneNumber: customer?.phoneNumber,
                                                              fullName: customer?.name)
        networkManager.bookByBusiness(modelTask: modelBookByBusinessTask) { [weak self] bookedTurn, error in
            guard let self = self else { return }
            if error as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: self.screenName)
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
                                                 screenName: self.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            self.view?.stopWaitingView()
            self.popToViewController()
            self.postBookedTurn(bookedTurn: bookedTurn)
        }
    }
    
    // MARK: - Public Interface
    func trackScreen() {
        let selectedDate = bookedSlot?.slot?.toString().toDisplayableDate(type: .date)
        let startTime = bookedSlot?.slot?.toString().toDisplayableDate(type: .hour)
        let bookedServicesDuration = ServiceTimeCalculation.calculateDuration(to: bookedServices)
        let endTimeDate = bookedSlot?.slot?.toString().calculateEndDate(adding: bookedServicesDuration)
        let endTime = endTimeDate?.toDisplayableDate(type: .hour)
        
        analyticsManager.track(eventKey: self.screenSeenKey, withProperties: [
            .turnIdentifier: turnId ?? "",
            .selectedDate: selectedDate ?? "",
            .startTime: startTime ?? "",
            .endTime: endTime ?? ""
        ])
    }
    
    func confirmButtonTapped() {
        trackButtonTapped(buttonText: Constants.confirmAnalyticValue)
        view?.startWaitingView()
        if userDelegate != nil {
            bookByUser()
        }
        if businessDelegate != nil {
            bookByBusiness()
        }
    }
    
    func cancelButtonTapped() {
        trackButtonTapped(buttonText: Constants.cancelTurnAnalyticValue)
        view?.showPopupView(withTitle: LocalizedConstants.cancel_turn_title_key.localized,
                            withText: LocalizedConstants.cancel_turn_message_key.localized,
                            withButton: LocalizedConstants.no_key.localized,
                            button2: LocalizedConstants.yes_key.localized,
                            completion: { [weak self] no, yes in
                                guard let self = self else { return }
                                if no == true {
                                    self.analyticsManager.track(eventKey: .alertActionTapped, withProperties: [
                                        .actionText: Constants.noAnalyticValue,
                                        .screenName: self.screenName
                                    ])
                                }
                                if yes == true {
                                    self.analyticsManager.track(eventKey: .alertActionTapped, withProperties: [
                                        .actionText: Constants.yesAnalyticValue,
                                        .screenName: self.screenName
                                    ])
                                    self.cancelTurnConfirmed(turnId: self.turnId)
                                }
                            })
    }
    
    func callNowButtonTapped() {
        trackButtonTapped(buttonText: Constants.callNowAnalyticValue)
        if let phoneNumber = customer?.phoneNumber {
            view?.call(phoneNumber)
        }
    }
    
    func blockButtonTapped() {
        trackButtonTapped(buttonText: Constants.blockUserAnalyticValue)
        view?.showPopupView(withTitle: LocalizedConstants.block_user_key.localized,
                            withText: String(format: LocalizedConstants.block_user_by_name_key.localized, customer?.name ?? ""),
                            withButton: LocalizedConstants.no_key.localized,
                            button2: LocalizedConstants.yes_key.localized,
                            completion: { [weak self] cancel, yes in
                                guard let self = self else { return }
                                if cancel == true {
                                    self.analyticsManager.track(eventKey: .alertActionTapped, withProperties: [
                                        .actionText: Constants.cancelAnalyticValue,
                                        .screenName: self.screenName
                                    ])
                                }
                                if yes != nil && yes == true {
                                    self.analyticsManager.track(eventKey: .alertActionTapped, withProperties: [
                                        .actionText: Constants.yesAnalyticValue,
                                        .screenName: self.screenName
                                    ])
                                    self.blockUserConfirmed()
                                }})
    }
}

private extension PresenterConfirmation {
    func trackButtonTapped(buttonText: String) {
        analyticsManager.track(eventKey: .buttonTapped, withProperties: [
            .buttonText: buttonText,
            .screenName: self.screenName
        ])
    }
}

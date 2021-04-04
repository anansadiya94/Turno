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
    private weak var view: PresenterConfirmationView?
    private var networkManager: NetworkManagerProtocol
    var delegate: Any?
    var identifier: String?
    var name: String?
    var bookedServices: [Service]?
    var bookedSlot: EmptySlot?
    var confirmationViewType: ConfirmationViewType?
    var customer: Customer?
    
    // MARK: - init Methods
    init(view: PresenterConfirmationView, networkManager: NetworkManagerProtocol, delegate: SelectButtonEntity,
         identifier: String?, name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?, confirmationViewType: ConfirmationViewType?) {
        self.view = view
        self.networkManager = networkManager
        self.delegate = delegate
        self.identifier = identifier
        self.name = name
        self.bookedServices = bookedServices
        self.bookedSlot = bookedSlot
        self.confirmationViewType = confirmationViewType
        self.notifyView()
    }
    
    init(view: PresenterConfirmationView, networkManager: NetworkManagerProtocol, delegate: SelectButtonBusiness,
         identifier: String?, name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?,
         confirmationViewType: ConfirmationViewType?, customer: Customer?) {
        self.view = view
        self.networkManager = networkManager
        self.delegate = delegate
        self.identifier = identifier
        self.name = name
        self.bookedServices = bookedServices
        self.bookedSlot = bookedSlot
        self.confirmationViewType = confirmationViewType
        self.customer = customer
        self.notifyView()
    }
    
    // MARK: - Private methods
    private func notifyView() {
        view?.didSetData(name: customer?.name, bookedServices: bookedServices,
                         bookedSlot: bookedSlot, confirmationViewType: confirmationViewType)
    }
    
    private func popToViewController() {
        if delegate as? SelectButtonEntity != nil {
            self.view?.popToBusinessViewController(animated: true)
        }
        if delegate as? SelectButtonBusiness != nil {
            self.view?.popToBusinessHomeViewController(animated: true)
        }
    }
    
    private func postBookedturn(bookedTurn: Turn?) {
        if delegate as? SelectButtonEntity != nil {
            if let bookedTurn = bookedTurn {
                let bookedTurnDict: [String: Turn] = ["bookedTurn": bookedTurn]
                NotificationCenter.default.post(name: Appointments.appointmentConfirmed, object: nil,
                userInfo: bookedTurnDict)
            }
        }
        if delegate as? SelectButtonBusiness != nil {
            if var bookedTurn = bookedTurn {
                bookedTurn.userName = customer?.name
                bookedTurn.userPhone = customer?.phoneNumber
                let bookedTurnDict: [String: Turn] = ["bookedTurn": bookedTurn]
                NotificationCenter.default.post(name: Appointments.appointmentConfirmed, object: nil,
                userInfo: bookedTurnDict)
            }
        }
    }
    
    private func blockUserConfirmed() {
        self.view?.startWaitingView()
        let modelBlockUser = ModelBlockUser(userId: identifier)
        networkManager.blockUser(modelBlockUser: modelBlockUser) { _, error in
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
        networkManager.cancelTurn(modelTask: modelCancelTurnTask) { _, error in
            if error as? MoyaError != nil {
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
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
            self.popToViewController()
        }
    }
    
    private func bookByUser() {
        var servicesToBook: [ServiceToBook] = []
        bookedServices?.forEach({ servicesToBook.append(ServiceToBook(identifier: $0.identifier,
                                                                      count: $0.count)) })
        let modelBookTask = ModelBookTask(servicesToBook: servicesToBook,
                                          dateTime: bookedSlot?.slot?.fromDisplayableHourToFormatted())
        networkManager.book(modelTask: modelBookTask) { bookedTurn, error in
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
            self.popToViewController()
            self.postBookedturn(bookedTurn: bookedTurn)
        }
    }
    
    private func bookByBusiness() {
        var servicesToBook: [ServiceToBook] = []
        bookedServices?.forEach({ servicesToBook.append(ServiceToBook(identifier: $0.identifier,
                                                                      count: $0.count)) })
        let modelBookByBusinessTask = ModelBookByBusinessTask(servicesToBook: servicesToBook,
                                          dateTime: bookedSlot?.slot?.fromDisplayableHourToFormatted(),
                                          phoneNumber: customer?.phoneNumber,
                                          fullName: customer?.name)
        networkManager.bookByBusiness(modelTask: modelBookByBusinessTask) { bookedTurn, error in
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
            self.popToViewController()
            self.postBookedturn(bookedTurn: bookedTurn)
        }
    }
    
    // MARK: - Public Interface
    func confirmButtonTapped() {
        self.view?.startWaitingView()
        if delegate as? SelectButtonEntity != nil {
            bookByUser()
        }
        if delegate as? SelectButtonBusiness != nil {
            bookByBusiness()
        }
    }
    
    func cancelButtonTapped() {
        self.view?.showPopupView(withTitle: LocalizedConstants.cancel_turn_title_key.localized,
                                 withText: LocalizedConstants.cancel_turn_message_key.localized,
                                 withButton: LocalizedConstants.no_key.localized,
                                 button2: LocalizedConstants.yes_key.localized,
                                 completion: { (_, yes) in
                                    if yes == true {
                                        self.cancelTurnConfirmed(turnId: self.identifier)
                                    }
        })
    }
    
    func callNowButtonTapped() {
        if let phoneNumber = customer?.phoneNumber {
            self.view?.call(phoneNumber)
        }
    }
    
    func blockButtonTapped() {
        self.view?.showPopupView(withTitle: LocalizedConstants.block_user_key.localized,
                                 withText: String(format: LocalizedConstants.block_user_by_name_key.localized, customer?.name ?? ""),
                                 withButton: LocalizedConstants.cancel_key.localized,
                                 button2: LocalizedConstants.yes_key.localized,
                                 completion: { (_, action2) in
                                    if action2 != nil && action2 == true {
                                        self.blockUserConfirmed()
                                    }})
    }
}

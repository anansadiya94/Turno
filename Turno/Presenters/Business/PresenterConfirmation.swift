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
    var delegate: Any?
    var identifier: String?
    var name: String?
    var bookedServices: [Service]?
    var bookedSlot: EmptySlot?
    var confirmationViewType: ConfirmationViewType?
    let networkManager = NetworkManager()
    var customer: Customer?
    
    // MARK: - init Methods
    init(view: PresenterConfirmationView, delegate: SelectButtonEntity, identifier: String?, name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?, confirmationViewType: ConfirmationViewType?) {
        self.view = view
        self.delegate = delegate
        self.identifier = identifier
        self.name = name
        self.bookedServices = bookedServices
        self.bookedSlot = bookedSlot
        self.confirmationViewType = confirmationViewType
        self.notifyView()
    }
    
    init(view: PresenterConfirmationView, delegate: SelectButtonBusiness, identifier: String?, name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?, confirmationViewType: ConfirmationViewType?, customer: Customer?) {
        self.view = view
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
        // TODO: BLOCK USER REQUEST
    }
    
    // MARK: - Public Interface
    func confirmButtonTapped() {
        self.view?.startWaitingView()
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
    
    func cancelButtonTapped() {
        // TODO: What should I do now?
    }
    
    func callNowButtonTapped() {
        if let phoneNumber = customer?.phoneNumber {
            self.view?.call(phoneNumber)
        }
    }
    
    func blockButtonTapped() {
        self.view?.showPopupView(withTitle: "Block user",
                                 withText: "Are you sure you want to block \(customer?.name ?? "")?",
                                 withButton: LocalizedConstants.cancel_key.localized,
                                 button2: LocalizedConstants.yes_key.localized,
                                 completion: { (_, action2) in
                                    if action2 != nil && action2 == true {
                                        self.blockUserConfirmed()
                                    }})
    }
}

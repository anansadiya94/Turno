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
    func didSetData(name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?)
}

class PresenterConfirmation {
    
    // MARK: - Properties
    private weak var view: PresenterConfirmationView?
    var delegate: SelectButtonEntity!
    var identifier: String?
    var name: String?
    var bookedServices: [Service]?
    var bookedSlot: EmptySlot?
    let networkManager = NetworkManager()
    
    // MARK: - init Methods
    init(view: PresenterConfirmationView, delegate: SelectButtonEntity, identifier: String?, name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?) {
        self.view = view
        self.delegate = delegate
        self.identifier = identifier
        self.name = name
        self.bookedServices = bookedServices
        self.bookedSlot = bookedSlot
        self.notifyView()
    }
    
    // MARK: - Private methods
    private func notifyView() {
        view?.didSetData(name: name, bookedServices: bookedServices, bookedSlot: bookedSlot)
    }
    
    // MARK: - Public Interface
    func confirmButtonTapped() {
        self.view?.startWaitingView()
        let modelBookTask = ModelBookTask(servicesToBook: bookedServices,
                                          dateTime: bookedSlot?.slot?.fromDisplayableHourToFormatted())
        networkManager.book(modelTask: modelBookTask) { _, error in
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
            //TODO: Booked successfully. What to do next?
        }
    }
}

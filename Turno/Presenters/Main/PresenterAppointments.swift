//
//  PresenterAppointments.swift
//  Turno
//
//  Created by Anan Sadiya on 07/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterAppointmentsView: PresenterParentView {
    func didSetData(model: AppointmentsListDescriptive)
    func call(_ number: String)
    func showEmptyMessage(title: String, message: String)
    func removeEmptyMessage()
}

class PresenterAppointments {
    
    // MARK: - Properties
    private weak var view: PresenterAppointmentsView?
    var delegate: SelectButtonEntity!
    var modelList = [ModelBusiness]()
    let networkManager = NetworkManager()
    
    // MARK: - init Methods
    init(view: PresenterAppointmentsView, delegate: SelectButtonEntity) {
        self.view = view
        self.fetchData()
        self.delegate = delegate
    }
    
    // MARK: - Private methods
    private func notifyView() {
        var newListModel: [ModelAppointment] = []
        for model in modelList {
            if let turns = model.turns {
                turns.forEach({newListModel.append(ModelAppointment(identifier: model.identifier,
                                                                    name: model.name,
                                                                    image: model.image,
                                                                    address: model.address,
                                                                    turn: $0,
                                                                    phone: model.phone))})
            }
        }
        
        let appointmentsListDescriptive = AppointmentsListDescriptive(modelList: newListModel)
        self.view?.didSetData(model: appointmentsListDescriptive)
    }
    
    // MARK: - Public Interface
    func fetchData() {
        self.view?.startWaitingView()
        self.view?.removeEmptyMessage()
        let modelBusinessTask = ModelBusinessTask(query: "")
        networkManager.getBusinesses(modelTask: modelBusinessTask) { (modelList, error) in
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
            if let modelList = modelList, !modelList.isEmpty {
                self.modelList = modelList
            } else {
                self.modelList = []
                // TODO: Translate
                self.view?.showEmptyMessage(title: "No turns found",
                                            message: "Schedule a turn to see it here.")
            }
            self.notifyView()
        }
    }
    
    func cancelTapped(turnId: String) {
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
        }
    }
    
    func callNowTapped(phone: String) {
        self.view?.call(phone)
    }
}
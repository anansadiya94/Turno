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
            self.fetchData()
        }
    }
    
    private func areThereTurns(modelList: [ModelBusiness]) -> Bool {
        var areThereTurns = false
        modelList.forEach { (model) in
            if let turns = model.turns, !turns.isEmpty {
                areThereTurns = true
            }
        }
        return areThereTurns
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
            if let modelList = modelList, !modelList.isEmpty, self.areThereTurns(modelList: modelList) {
                self.modelList = modelList
            } else {
                self.modelList = []                
                self.view?.showEmptyMessage(title: LocalizedConstants.no_turns_error_title_key.localized,
                                            message: LocalizedConstants.no_turns_error_message_key.localized)
            }
            self.notifyView()
        }
    }
    
    func cancelTapped(turnId: String) {
        // TODO: Translate
        self.view?.showPopupView(withTitle: "Are you sure you want to cancal this turn?",
                                 withText: "Are you sure you want to cancal this turn?",
                                 withButton: "No", button2: "Yes",
                                 completion: { (_, yes) in
                                    if yes == true {
                                        self.cancelTurnConfirmed(turnId: turnId)
                                    }
        })
    }
    
    func callNowTapped(phone: String) {
        self.view?.call(phone)
    }
}

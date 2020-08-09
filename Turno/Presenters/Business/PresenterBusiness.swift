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
}

class PresenterBusiness {
    
    // MARK: - Properties
    private weak var view: PresenterBusinessView?
    var delegate: SelectButtonEntity!
    var model: ModelBusiness?
    let networkManager = NetworkManager()
    
    // MARK: - init Methods
    init(view: PresenterBusinessView, delegate: SelectButtonEntity, model: ModelBusiness) {
        self.view = view
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
        delegate.didSelectCheckAvailability(identifier: identifier, name: model?.name, bookedServices: bookedServices)
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
        self.view?.showPopupView(withTitle: "Are you sure you want to cancal this turn?",
                                 withText: "Are you sure you want to cancal this turn?",
                                 withButton: "No", button2: "Yes",
                                 completion: { (_, yes) in
                                    if yes == true {
                                        self.cancelTurnConfirmed(turnId: turnId)
                                    }
        })
    }
}

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
    
    // MARK: - Public Interface
    func modifyModel(identifier: String, count: Int) {
        view?.modifyModel(identifier: identifier, count: count)
    }
    
    func checkAvailabilityButtonTapped(identifier: String?, services: [Service]?) {
        //TODO
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
}

//
//  PresenterCheckAvailability.swift
//  Turno
//
//  Created by Anan Sadiya on 06/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterCheckAvailabilityView: PresenterParentView {
    func didSetData(name: String?)
}

class PresenterCheckAvailability {
    
    // MARK: - Properties
    private weak var view: PresenterCheckAvailabilityView?
    var delegate: SelectButtonEntity!
    var identifier: String?
    var name: String?
    var bookedServices: [Service]?
    let networkManager = NetworkManager()
    
    // MARK: - init Methods
    init(view: PresenterCheckAvailabilityView, delegate: SelectButtonEntity, identifier: String?, name: String?, bookedServices: [Service]?) {
        self.view = view
        self.delegate = delegate
        self.identifier = identifier
        self.name = name
        self.bookedServices = bookedServices
        self.notifyView()
    }
    
    // MARK: - Private methods
    private func notifyView() {
        view?.didSetData(name: name)
    }    
}

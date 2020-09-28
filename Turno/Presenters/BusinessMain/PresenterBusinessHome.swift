//
//  PresenterBusinessHome.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterBusinessHomeView: class {
    func didSetData()
}

class PresenterBusinessHome {
    
    // MARK: - Properties
    private weak var view: PresenterBusinessHomeView?
    var delegate: SelectButtonBusiness!
    
    // MARK: - init Methods
    init(view: PresenterBusinessHomeView, delegate: SelectButtonBusiness) {
        self.view = view
        self.delegate = delegate
        view.didSetData()
    }

    func addAppointmentTapped() {
        delegate.addAppointmentTapped()
    }
    
    func showAppointmentTapped() {
        delegate.showAppointmentTapped()
    }
}

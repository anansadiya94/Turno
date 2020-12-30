//
//  PresenterSettings.swift
//  Turno
//
//  Created by Anan Sadiya on 22/11/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

protocol PresenterSettingsView: PresenterParentView {
    func share()
}

class PresenterSettings: NSObject {
    
    // MARK: - Properties
    private weak var view: PresenterSettingsView?
    var delegate: Any?
    
    // MARK: - init Methods
    init(view: PresenterSettingsView, delegate: SelectButtonEntity) {
        self.view = view
        self.delegate = delegate
    }
    
    init(view: PresenterSettingsView, delegate: SelectButtonBusiness) {
        self.view = view
        self.delegate = delegate
    }
    
    func changeToUser() {
        if let delegate = delegate as? SelectButtonBusiness {
            AppData.isBusiness = false
            delegate.didSelectChangeToUser()
        }
    }
    
    func changeToBusiness() {
        if let delegate = delegate as? SelectButtonEntity {
            AppData.isBusiness = true
            delegate.didSelectChangeToBusiness()
        }
    }
    
    func share() {
        self.view?.share()
    }
    
    func notifications() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
           UIApplication.shared.open(settingsUrl)
         }
    }
    
    func blockedUsers() {
        if let delegate = delegate as? SelectButtonBusiness {
            delegate.didSelectBlockedUsers()
        }
    }
}

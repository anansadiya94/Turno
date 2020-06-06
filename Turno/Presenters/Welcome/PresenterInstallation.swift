//
//  PresenterInstallation.swift
//  Turno
//
//  Created by Anan Sadiya on 05/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class PresenterInstallation: NSObject {
    
    // MARK: - Properties
    var view: InstallationViewController!
    var delegate: SelectButtonWelcome!
    
    // MARK: - Public Interface
    init(view: InstallationViewController, delegate: SelectButtonWelcome) {
        super.init()
        self.view = view
        self.delegate = delegate
    }
    
    private func isValid(name: String?, phoneNumber: String?) -> Bool {
        return true
    }
    
    private func invalidInputAlert() {
        //TODO
    }
    
    private func showAlert() {
        let modelAlertPopUp = ModelAlertPopup(title: LocalizedConstants.phone_number_question_key.localized,
                                              message: Preferences.getPrefsUser()?.phoneNumber,
                                              action1: LocalizedConstants.edit_key.localized,
                                              action2: LocalizedConstants.yes_key.localized)
        delegate.showAlert(view: view, modelAlertPopup: modelAlertPopUp)
    }
    
    // MARK: - UI interaction methods
    func continueButtonTapped(name: String?, phoneNumber: String?) {
        if isValid(name: name, phoneNumber: phoneNumber) {
            let user = User(name: name, phoneNumber: phoneNumber)
            Preferences.setPrefsUser(user: user)
            showAlert()
        } else {
            invalidInputAlert()
        }
    }
}

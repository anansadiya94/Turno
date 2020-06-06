//
//  PresenterInstallation.swift
//  Turno
//
//  Created by Anan Sadiya on 05/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

protocol PresenterInstallationView: class {
    func showNameTextFieldLabel(type: TextFieldErrorType)
    func showPhoneNumberTextFieldLabel(type: TextFieldErrorType)
}

class PresenterInstallation {
    
    // MARK: - Properties
    var view: InstallationViewController!
    var delegate: SelectButtonWelcome!
    
    // MARK: - Public Interface
    init(view: InstallationViewController, delegate: SelectButtonWelcome) {
        self.view = view
        self.delegate = delegate
    }
    
    private func validateName(_ name: String?) -> Bool {
        let textFieldErrorType = ServiceTextFieldValidation.validateName(name)
        switch textFieldErrorType {
        case .valid:
            view.showNameTextFieldLabel(type: textFieldErrorType)
            return true
        case .empty_field_key, .invalid_name_key:
            view.showNameTextFieldLabel(type: textFieldErrorType)
        default:
            break
        }
        return false
    }
    
    private func validatePhoneNumber(_ phoneNumber: String?) -> Bool {
        let textFieldErrorType = ServiceTextFieldValidation.validatePhoneNumber(phoneNumber)
        switch textFieldErrorType {
        case .valid:
            view.showPhoneNumberTextFieldLabel(type: textFieldErrorType)
            return true
        case .empty_field_key, .invalid_phoneNumber_key:
            view.showPhoneNumberTextFieldLabel(type: textFieldErrorType)
        default:
            break
        }
        return false
    }
    
    private func isValid(name: String?, phoneNumber: String?) -> Bool {
        let isValidateName = validateName(name)
        let isValidatePhoneNumber = validatePhoneNumber(phoneNumber)
        if  isValidateName == true && isValidatePhoneNumber == true {
            return true
        } else {
            return false
        }
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
        }
    }
    
    func alertYesButtonTapped() {
        delegate.didSelectAlertYesButton()
    }
}

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
    func showAlert()
}

class PresenterInstallation {
    
    // MARK: - Properties
    var view: InstallationViewController!
    var delegate: SelectButtonWelcome!
    let networkManager = NetworkManager()
    
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
    
    // MARK: - UI interaction methods
    func continueButtonTapped(name: String?, phoneNumber: String?) {
        if isValid(name: name, phoneNumber: phoneNumber) {
            let user = User(name: name, phoneNumber: phoneNumber)
            Preferences.setPrefsUser(user: user)
            view?.showAlert()
        }
    }
    
    func alertYesButtonTapped() {
        self.view.startWaiting()
        if let phoneNumber = Preferences.getPrefsUser()?.phoneNumber, let fullName = Preferences.getPrefsUser()?.name {
            let modelSignUp = ModelSignUp(phoneNumber: phoneNumber, fullName: fullName)
            networkManager.signUp(modelSignUp: modelSignUp) { (modelSignUpResponse, error) in
                if let error = error {
                    self.view.stopWaiting()
                    //TODO
                    self.view.showPopup(withTitle: "ERROR", withText: error.localizedDescription, withButton: "OK", completion: nil)
                    return
                }
                if let modelSignUpResponse = modelSignUpResponse {
                    self.view.stopWaiting()
                    self.delegate.didSelectAlertYesButton(modelSignUpResponse: modelSignUpResponse)
                }
            }
        }
    }
}

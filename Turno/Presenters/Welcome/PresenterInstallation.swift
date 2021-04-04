//
//  PresenterInstallation.swift
//  Turno
//
//  Created by Anan Sadiya on 05/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Moya

protocol PresenterInstallationView: PresenterParentView {
    func showNameTextFieldLabel(type: TextFieldErrorType)
    func showPhoneNumberTextFieldLabel(type: TextFieldErrorType)
    func showAlert()
}

class PresenterInstallation {
    
    // MARK: - Properties
    private weak var view: PresenterInstallationView!
    private var networkManager: NetworkManagerProtocol
    private var delegate: SelectButtonWelcome?
    
    // MARK: - Public Interface
    init(view: PresenterInstallationView, networkManager: NetworkManagerProtocol, delegate: SelectButtonWelcome) {
        self.view = view
        self.networkManager = networkManager
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
        self.view?.startWaitingView()
        if let phoneNumber = Preferences.getPrefsUser()?.phoneNumber, let fullName = Preferences.getPrefsUser()?.name {
            let modelSignUpTask = ModelSignUpTask(phoneNumber: phoneNumber, fullName: fullName)
            networkManager.signUp(modelTask: modelSignUpTask) { (modelSignUp, error) in
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
                if let modelSignUp = modelSignUp {
                    self.view?.stopWaitingView()
                    self.delegate?.didSelectAlertYesButton(modelSignUp: modelSignUp)
                }
            }
        }
    }
}

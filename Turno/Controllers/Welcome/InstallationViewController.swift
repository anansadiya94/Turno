//
//  InstallationViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 05/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class InstallationViewController: ParentViewController {
    
    // MARK: - Properties
    var presenterInstallation: PresenterInstallation!
    var installationView: InstallationView?
    
    override var navBarTitle: String {
        return LocalizedConstants.installation_key.localized
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setInstallationView()
        addTarget()
        hideKeyboardWhenTappedAround()
        configureTextFields()
        addToolBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        installationView?.nameTextField.becomeFirstResponder()
        presenterInstallation.trackScreen()
    }
    
    // MARK: - Private methods    
    private func setInstallationView() {
        installationView = InstallationView(frame: view.frame)
        self.view = installationView
    }
    
    private func addTarget() {
        installationView?.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    private func configureTextFields() {
        installationView?.nameTextField.delegate = self
        installationView?.phoneNumberTextField.delegate = self
    }
    
    private func addToolBar() {
        addCancelAndButtonsOnKeyboard(textField: installationView?.phoneNumberTextField)
    }
    
    // MARK: - UI interaction methods
    @objc func continueButtonTapped() {
        installationView?.phoneNumberTextField.resignFirstResponder()
        presenterInstallation.continueButtonTapped(name: installationView?.nameTextField.text,
                                                   phoneNumber: installationView?.phoneNumberTextField.text ?? "")
    }
    
    @objc func cancelButtonTapped() {
        installationView?.phoneNumberTextField.resignFirstResponder()
    }
}

// TOOD IMPROVE ME
extension InstallationViewController {
    func addCancelAndButtonsOnKeyboard(textField: UITextField?) {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel: UIBarButtonItem = UIBarButtonItem(title: LocalizedConstants.cancel_key.localized, style: .plain,
                                                      target: self, action: #selector(self.cancelButtonTapped))
        let done: UIBarButtonItem = UIBarButtonItem(title: LocalizedConstants.continue_key.localized, style: .done,
                                                    target: self, action: #selector(self.continueButtonTapped))
        
        cancel.tintColor = .primary
        done.tintColor = .primary
        
        let items = [cancel, flexSpace, done]
        toolbar.items = items
        toolbar.sizeToFit()
        
        textField?.inputAccessoryView = toolbar
    }
}

// MARK: - UITextFieldDelegate methods
extension InstallationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        installationView?.phoneNumberTextField.becomeFirstResponder()
        return false
    }
}

// MARK: - PresenterInstallationView methods
extension InstallationViewController: PresenterInstallationView {    
    func showNameTextFieldLabel(type: TextFieldErrorType) {
        var isValid: Bool = true
        var message = ""
        switch type {
        case .valid:
            installationView?.setTextFieldLabel(textFieldLabel: installationView?.phoneNumberTextFieldLabel, isHidden: true)
        case .emptyFieldKey:
            isValid = false
            message = LocalizedConstants.empty_field_key.localized
        case .invalidNameKey:
            isValid = false
            message = LocalizedConstants.invalid_name_key.localized
        default:
            break
        }
        installationView?.setTextFieldLabel(textFieldLabel: installationView?.nameTextFieldLabel, message: message, isHidden: false)
        installationView?.setTextFieldLayer(textField: installationView?.nameTextField, isValid: isValid)
    }
    
    func showPhoneNumberTextFieldLabel(type: TextFieldErrorType) {
        var isValid: Bool = true
        var message = ""
        switch type {
        case .valid:
            installationView?.setTextFieldLabel(textFieldLabel: installationView?.phoneNumberTextFieldLabel, isHidden: true)
        case .emptyFieldKey:
            isValid = false
            message = LocalizedConstants.empty_field_key.localized
        case .invalidPhoneNumberKey:
            isValid = false
            message = LocalizedConstants.invalid_phoneNumber_key.localized
        default:
            break
        }
        installationView?.setTextFieldLabel(textFieldLabel: installationView?.phoneNumberTextFieldLabel, message: message, isHidden: false)
        installationView?.setTextFieldLayer(textField: installationView?.phoneNumberTextField, isValid: isValid)
    }
    
    func showAlert() {
        let modelAlertPopUp = ModelAlertPopup(title: LocalizedConstants.phone_number_question_key.localized,
                                              message: Preferences.getPrefsUser()?.phoneNumber,
                                              action1: LocalizedConstants.edit_key.localized,
                                              action2: LocalizedConstants.yes_key.localized)
        self.showPopup(withTitle: modelAlertPopUp.title, withText: modelAlertPopUp.message,
                       withButton: modelAlertPopUp.action1, button2: modelAlertPopUp.action2,
                       completion: { (action1, action2) in
                        if action1 != nil && action1 == true {
                            self.installationView?.phoneNumberTextField.becomeFirstResponder()
                        }
                        if action2 != nil && action2 == true {
                            self.presenterInstallation.alertYesButtonTapped()
                        }
                        
        })
    }
    
    func startWaitingView() {
        startWaiting()
    }
    
    func stopWaitingView() {
        stopWaiting()
    }
    
    func showPopupView(withTitle title: String?, withText text: String?, withButton button: String?, button2: String?, completion: ((Bool?, Bool?) -> Void)?) {
        showPopup(withTitle: title, withText: text, withButton: button, button2: button2, completion: completion)
    }
}

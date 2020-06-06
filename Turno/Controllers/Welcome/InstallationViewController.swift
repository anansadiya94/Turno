//
//  InstallationViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 05/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

class InstallationViewController: UIViewController {
    
    // MARK: - Properties
    var presenterInstallation: PresenterInstallation!
    var installationView: InstallationView?
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setWelcomeView()
        addTargets()
        hideKeyboardWhenTappedAround()
        configureTextFields()
        addToolBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        installationView?.nameTextField.becomeFirstResponder()
    }
    
    // MARK: - Private methods
    private func setNavigationBar() {
        navigationItem.title = LocalizedConstants.installation_key.localized
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setWelcomeView() {
        installationView = InstallationView(frame: view.frame)
        self.view = installationView
    }
    
    private func addTargets() {
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
        print("continue was tapped")
        presenterInstallation.continueButtonTapped(name: installationView?.nameTextField.text,
                                                   phoneNumber: installationView?.phoneNumberTextField.text ?? "")
    }
    
    @objc func cancelButtonTapped() {
        installationView?.phoneNumberTextField.resignFirstResponder()
    }
}

//TOOD IMPROVE ME
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
        case .empty_field_key:
            isValid = false
            message = LocalizedConstants.empty_field_key.localized
        case .invalid_name_key:
            isValid = false
            message = LocalizedConstants.name_key.localized
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
        case .empty_field_key:
            isValid = false
            message = LocalizedConstants.empty_field_key.localized
        case .invalid_phoneNumber_key:
            isValid = false
            message = LocalizedConstants.invalid_phoneNumber_key.localized
        default:
            break
        }
        installationView?.setTextFieldLabel(textFieldLabel: installationView?.phoneNumberTextFieldLabel, message: message, isHidden: false)
        installationView?.setTextFieldLayer(textField: installationView?.phoneNumberTextField, isValid: isValid)
    }
}

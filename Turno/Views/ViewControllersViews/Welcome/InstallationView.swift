//
//  InstallationView.swift
//  Turno
//
//  Created by Anan Sadiya on 05/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class InstallationView: UIView {
    
    // MARK: - Properties
    @UseAutoLayout var nameTextField = CustomTextField()
    @UseAutoLayout var nameTextFieldLabel = CustomLabel()
    @UseAutoLayout var phoneNumberTextField = CustomTextField()
    @UseAutoLayout var phoneNumberTextFieldLabel = CustomLabel()
    @UseAutoLayout var continueButton = RoundedCustomButtonWithMargin()
    
    // MARK: - Constraints constants
    private var kSuperViewMargin: CGFloat = 16
    private var kTextFieldHeight: CGFloat = 44
    
    // MARK: - UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func configureUI() {
        addSubviews()
        addNameTextField()
        addNameTextFieldLabel()
        addPhoneNumberTextField()
        addPhoneNumberTextFieldLabel()
        addContinueButton()
    }
    
    private func addSubviews() {
        self.addSubview(nameTextField)
        self.addSubview(nameTextFieldLabel)
        self.addSubview(phoneNumberTextField)
        self.addSubview(phoneNumberTextFieldLabel)
        self.addSubview(continueButton)
    }
    
    private func addNameTextField() {
        nameTextField.textFieldTheme = NameTheme(placeholder: LocalizedConstants.name_key.localized,
                                                 icon: kName, returnKeyType: .next)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: kSuperViewMargin),
            nameTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            nameTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin),
            nameTextField.heightAnchor.constraint(equalToConstant: kTextFieldHeight)
        ])
    }
    
    private func addNameTextFieldLabel() {
        nameTextFieldLabel.isHidden = true
        nameTextFieldLabel.labelTheme = LightTheme(label: "", fontSize: 10, textColor: .red, textAlignment: .left)
        NSLayoutConstraint.activate([
            nameTextFieldLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameTextFieldLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            nameTextFieldLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin)
        ])
    }
    
    private func addPhoneNumberTextField() {
        phoneNumberTextField.textFieldTheme = PhoneNumberTheme(placeholder: LocalizedConstants.phone_number_key.localized,
                                                               icon: kPhoneNumber, returnKeyType: .done)
        NSLayoutConstraint.activate([
            phoneNumberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: kSuperViewMargin),
            phoneNumberTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            phoneNumberTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: kTextFieldHeight)
        ])
    }
    
    private func addPhoneNumberTextFieldLabel() {
        phoneNumberTextFieldLabel.isHidden = true
        phoneNumberTextFieldLabel.labelTheme = LightTheme(label: "", fontSize: 10, textColor: .red, textAlignment: .left)
        NSLayoutConstraint.activate([
            phoneNumberTextFieldLabel.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor),
            phoneNumberTextFieldLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            phoneNumberTextFieldLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin)
        ])
    }
    
    private func addContinueButton() {
        continueButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.continue_key.localized)
        NSLayoutConstraint.activate([
            continueButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin*2),
            continueButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin*2),
            continueButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -kSuperViewMargin*2)
        ])
    }
    
    // MARK: - Public Interface
    func setTextFieldLabel(textFieldLabel: CustomLabel?, message: String = "", isHidden: Bool) {
        textFieldLabel?.text = message
        textFieldLabel?.isHidden = isHidden
    }
    
    func setTextFieldLayer(textField: UITextField?, isValid: Bool) {
        textField?.layer.borderColor = isValid ? UIColor.primary.cgColor : UIColor.red.cgColor
    }
}

//
//  AddAppointmentView.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class AddAppointmentView: UIView {
    
    // MARK: - Properties
    @UseAutoLayout var clientInformationLabel = CustomLabel()
    @UseAutoLayout var nameTextField = CustomTextField()
    @UseAutoLayout var nameTextFieldLabel = CustomLabel()
    @UseAutoLayout var phoneNumberTextField = CustomTextField()
    @UseAutoLayout var phoneNumberTextFieldLabel = CustomLabel()
    @UseAutoLayout var servicesLabel = CustomLabel()
    @UseAutoLayout var tableView = UITableView()
    @UseAutoLayout var checkAvailabilityButton =  RoundedCustomButton()
    
    // MARK: - Constraints constants
    private var kViewMargin: CGFloat = 8
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
        addClientInformationLabel()
        addNameTextField()
        addNameTextFieldLabel()
        addPhoneNumberTextField()
        addPhoneNumberTextFieldLabel()
        addServicesLabel()
        createTableView()
        createCheckAvailabilityButton()
    }
    
    private func addSubviews() {
        self.addSubview(clientInformationLabel)
        self.addSubview(nameTextField)
        self.addSubview(nameTextFieldLabel)
        self.addSubview(phoneNumberTextField)
        self.addSubview(phoneNumberTextFieldLabel)
        self.addSubview(servicesLabel)
        self.addSubview(checkAvailabilityButton)
    }
    
    private func addClientInformationLabel() {
        clientInformationLabel.labelTheme = BoldTheme(label: LocalizedConstants.client_information_key.localized,
                                                      fontSize: 18.0, textColor: .black, textAlignment: .natural)
        NSLayoutConstraint.activate([
            clientInformationLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: kViewMargin),
            clientInformationLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            clientInformationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin)
        ])
    }
    
    private func addNameTextField() {
        nameTextField.textFieldTheme = NameTheme(placeholder: LocalizedConstants.name_key.localized,
                                                 icon: kName, returnKeyType: .next)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: clientInformationLabel.bottomAnchor, constant: kViewMargin),
            nameTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            nameTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin),
            nameTextField.heightAnchor.constraint(equalToConstant: kTextFieldHeight)
        ])
    }
    
    private func addNameTextFieldLabel() {
        nameTextFieldLabel.isHidden = true
        nameTextFieldLabel.labelTheme = Lightheme(label: "", fontSize: 10, textColor: .red, textAlignment: .left)
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
        phoneNumberTextFieldLabel.labelTheme = Lightheme(label: "", fontSize: 10, textColor: .red, textAlignment: .left)
        NSLayoutConstraint.activate([
            phoneNumberTextFieldLabel.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor),
            phoneNumberTextFieldLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            phoneNumberTextFieldLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin)
        ])
    }
    
    private func addServicesLabel() {
        servicesLabel.labelTheme = BoldTheme(label: LocalizedConstants.services_key.localized,
                                             fontSize: 18.0, textColor: .black, textAlignment: .natural)
        NSLayoutConstraint.activate([
            servicesLabel.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: kSuperViewMargin),
            servicesLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            servicesLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin)
        ])
    }
    
    private func createCheckAvailabilityButton() {
        addSubview(checkAvailabilityButton)
        checkAvailabilityButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.check_availability_key.localized)
        setCheckAvailabilityButton(0)
        
        NSLayoutConstraint.activate([
            checkAvailabilityButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            checkAvailabilityButton.heightAnchor.constraint(equalToConstant: 44.0),
            checkAvailabilityButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 32.0),
            checkAvailabilityButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -32.0)
        ])
    }
    
    private func createTableView() {
        addSubview(tableView)
        tableView.alwaysBounceVertical = true
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: checkAvailabilityButton.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: servicesLabel.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor, constant: kSuperViewMargin),
            tableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -kSuperViewMargin)
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
    
    func setCheckAvailabilityButton(_ count: Int) {
        checkAvailabilityButton.isEnabled = count >= 1 ? true : false
        checkAvailabilityButton.backgroundColor = count >= 1 ? .primary : UIColor.primary.withAlphaComponent(0.5)
    }
}

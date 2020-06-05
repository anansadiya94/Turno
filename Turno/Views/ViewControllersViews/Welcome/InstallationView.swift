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
    @UseAutoLayout var nameTextField = UITextField()
    @UseAutoLayout var phoneNumberTextField = UITextField()
    @UseAutoLayout var continueButton = RoundedCustomButtonWithMargin()
    
    // MARK: - Constraints constants
    private var kSuperViewMargin: CGFloat = 16
    
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
//        addNameTextField()
//        addPhoneNumberTextField()
        addContinueButton()
    }

    func addSubviews() {
        self.addSubview(nameTextField)
        self.addSubview(phoneNumberTextField)
        self.addSubview(continueButton)
    }
    
//    private func addNameTextField() {
//        continueLabel.labelTheme = RegularTheme(label: LocalizedConstants.agree_to_terms_key.localized,
//                                                fontSize: 15, textColor: .black, textAlignment: .center)
//        NSLayoutConstraint.activate([
//            continueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            continueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            continueLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
//            continueLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin)
//        ])
//    }
//
//    private func addPhoneNumberTextField() {
//        continueButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.continue_key.localized)
//        NSLayoutConstraint.activate([
//            continueButton.topAnchor.constraint(equalTo: continueLabel.bottomAnchor, constant: kSuperViewMargin),
//            continueButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
//        ])
//    }
    
    private func addContinueButton() {
        continueButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.continue_key.localized)
        NSLayoutConstraint.activate([
            continueButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin*2),
            continueButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin*2),
            continueButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -kSuperViewMargin*2)
        ])
    }
}

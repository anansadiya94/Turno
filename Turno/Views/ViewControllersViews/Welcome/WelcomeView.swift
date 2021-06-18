//
//  WelcomeView.swift
//  Turno
//
//  Created by Anan Sadiya on 04/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class WelcomeView: UIView {
    
    // MARK: - Properties
    @UseAutoLayout var logoImageView = UIImageView()
    @UseAutoLayout var welcomeLabel = CustomLabel()
    @UseAutoLayout var benefitsLabel = CustomLabel()
    @UseAutoLayout var continueLabel = CustomLabel()
    @UseAutoLayout var continueButton = RoundedCustomButtonWithMargin()
    @UseAutoLayout var footerView = UIView()
    @UseAutoLayout var footerLabel = CustomLabel()
    @UseAutoLayout var privacyPolicyButton = CustomButton()
    
    // MARK: - Constraints constants
    private var kSuperViewMargin: CGFloat = 16
    private var kSpaceBetweenElements: CGFloat = 2
    
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
        addContinueLabel()
        addContinueButton()
        addBenefitsLabel()
        addWelcomeLabel()
        addLogoImageView()
        addFooterView()
    }
    
    private func addSubviews() {
        self.addSubview(logoImageView)
        self.addSubview(welcomeLabel)
        self.addSubview(benefitsLabel)
        self.addSubview(continueLabel)
        self.addSubview(continueButton)
        self.addSubview(footerView)
    }
    
    private func addContinueLabel() {
        continueLabel.labelTheme = RegularTheme(label: LocalizedConstants.agree_to_terms_key.localized,
                                                fontSize: 15, textColor: .black, textAlignment: .center)
        NSLayoutConstraint.activate([
            continueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            continueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            continueLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            continueLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin)
        ])
    }
    
    private func addContinueButton() {
        continueButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.continue_key.localized)
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: continueLabel.bottomAnchor, constant: kSuperViewMargin),
            continueButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func addBenefitsLabel() {
        benefitsLabel.labelTheme = LightTheme(label: LocalizedConstants.benefits_text_key.localized,
                                              fontSize: 15, textColor: .black, textAlignment: .center)
        NSLayoutConstraint.activate([
            benefitsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            benefitsLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            benefitsLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin),
            benefitsLabel.bottomAnchor.constraint(equalTo: continueLabel.topAnchor, constant: -kSuperViewMargin*2)
        ])
    }
    
    private func addWelcomeLabel() {
        welcomeLabel.labelTheme = BoldTheme(label: LocalizedConstants.welcome_to_turno_key.localized,
                                            fontSize: 25, textColor: .black, textAlignment: .center)
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            welcomeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            welcomeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin),
            welcomeLabel.bottomAnchor.constraint(equalTo: benefitsLabel.topAnchor, constant: -kSuperViewMargin)
        ])
    }
    
    private func addLogoImageView() {
        logoImageView.layer.cornerRadius = 10.0
        logoImageView.layer.masksToBounds = true
        logoImageView.image = UIImage(named: kLogo)
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.bottomAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: -kSuperViewMargin*2),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func addFooterView() {        
        footerLabel.labelTheme = RegularTheme(label: "@2021 Turno", fontSize: 15,
                                              textColor: .black, textAlignment: .center)
        privacyPolicyButton.buttonTheme = BaseTheme(label: LocalizedConstants.privacy_policy_key.localized, underLine: true)
        
        footerView.addSubview(footerLabel)
        footerView.addSubview(privacyPolicyButton)
        
        NSLayoutConstraint.activate([
            footerLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            privacyPolicyButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            footerLabel.leftAnchor.constraint(equalTo: footerView.leftAnchor),
            footerLabel.rightAnchor.constraint(equalTo: privacyPolicyButton.leftAnchor, constant: -kSpaceBetweenElements),
            privacyPolicyButton.rightAnchor.constraint(equalTo: footerView.rightAnchor),
            footerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            footerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -kSuperViewMargin),
            footerView.heightAnchor.constraint(equalToConstant: kSuperViewMargin)
        ])
    }
}

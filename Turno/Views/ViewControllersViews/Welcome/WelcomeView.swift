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
    @UseAutoLayout var benefintsLabel = CustomLabel()
    @UseAutoLayout var continueLabel = CustomLabel()
    @UseAutoLayout var continueButton = RoundedCustomButton()
    @UseAutoLayout var footerLabel = CustomLabel()
    @UseAutoLayout var privacyPolicyButton = CustomButton()
    
    // MARK: - Constraints constants
    private var kSuperViewMargin: CGFloat = 32
    private var kSuperViewTopMargin: CGFloat = 16
    private var kHeightAnchor: CGFloat = 50
    private var kLeftRightAnchor: CGFloat = 55
    
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
        addBenefintsLabel()
        addWelcomeLabel()
        addLogoImageView()
        addFooterView()
    }

    func addSubviews() {
        self.addSubview(logoImageView)
        self.addSubview(welcomeLabel)
        self.addSubview(benefintsLabel)
        self.addSubview(continueLabel)
        self.addSubview(continueButton)
    }
    
    private func addContinueLabel() {
        continueLabel.labelTheme = RegularTheme(label: LocalizedConstants.agree_to_terms_key.localized,
                                                fontSize: 15, textColor: .black, textAlignment: .center)
        NSLayoutConstraint.activate([
            continueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            continueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            continueLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewTopMargin),
            continueLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewTopMargin)
        ])
    }
     
    private func addContinueButton() {
        continueButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.continue_key.localized)
        NSLayoutConstraint.activate([
            continueButton.widthAnchor.constraint(equalToConstant: 200),
            continueButton.topAnchor.constraint(equalTo: continueLabel.bottomAnchor, constant: kSuperViewTopMargin),
            continueButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func addBenefintsLabel() {
        benefintsLabel.labelTheme = Lightheme(label: LocalizedConstants.benefits_text_key.localized,
                                              fontSize: 15, textColor: .black, textAlignment: .center)
        NSLayoutConstraint.activate([
            benefintsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            benefintsLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewTopMargin),
            benefintsLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewTopMargin),
            benefintsLabel.bottomAnchor.constraint(equalTo: continueLabel.topAnchor, constant: -kSuperViewTopMargin)
        ])
    }
    
    private func addWelcomeLabel() {
        welcomeLabel.labelTheme = BoldTheme(label: LocalizedConstants.welcome_to_turno_key.localized,
                                               fontSize: 25, textColor: .black, textAlignment: .center)
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            welcomeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewTopMargin),
            welcomeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewTopMargin),
            welcomeLabel.bottomAnchor.constraint(equalTo: benefintsLabel.topAnchor, constant: -kSuperViewTopMargin)
        ])
    }
    
    private func addLogoImageView() {
        logoImageView.image = UIImage(named: kLogo)
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.bottomAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: -kSuperViewTopMargin),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func addFooterView() {
        //TODO: Should be translated?
        footerLabel.labelTheme = RegularTheme(label: "@2020 Turno", fontSize: 15,
                                              textColor: .black, textAlignment: .center)
        privacyPolicyButton.buttonTheme = BaseTheme(label: LocalizedConstants.privacy_policy_key.localized, underLine: true)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = -8
    
        stackView.addArrangedSubview(footerLabel)
        stackView.addArrangedSubview(privacyPolicyButton)
          
        self.addSubview(stackView)
          
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -kSuperViewTopMargin).isActive = true
    }
}

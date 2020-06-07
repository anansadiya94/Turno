//
//  ActivationView.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class ActivationView: UIView {
    
    // MARK: - Properties
    @UseAutoLayout var progressView = UIProgressView()
    @UseAutoLayout var titleLabel = CustomLabel()
    @UseAutoLayout var subTitleView = UIView()
    @UseAutoLayout var phoneNumberLabel = CustomLabel()
    @UseAutoLayout var wrongNumberButton = CustomButton()
    @UseAutoLayout var otpLabel = CustomLabel()
    @UseAutoLayout var otpView = UIView()
    @UseAutoLayout var countDownLabel = CustomLabel()
    @UseAutoLayout var resendSMSButton = CustomButton()
    @UseAutoLayout var activateByCallButton = CustomButton()
    @UseAutoLayout var finishButton = RoundedCustomButtonWithMargin()

    let otpStackView = OTPStackView()
    
    // MARK: - Constraints constants
    private var kSuperViewMargin: CGFloat = 16
    private var kTextFieldHeight: CGFloat = 44
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
        addProgressView()
        addTitleLabel()
        addSubTitleView()
        addOTPLabel()
        addOTPView()
        addCountDownLabel()
        addCenterButtons()
        addFinishButton()
    }

    private func addSubviews() {
        self.addSubview(progressView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleView)
        self.addSubview(otpLabel)
        self.addSubview(otpView)
        self.addSubview(countDownLabel)
        self.addSubview(finishButton)
    }

    private func addProgressView() {
        progressView.tintColor = .primary
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: kSuperViewMargin),
            progressView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            progressView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin)
        ])
    }
    
    private func addTitleLabel() {
        titleLabel.labelTheme = RegularTheme(label: LocalizedConstants.sms_sent_key.localized,
                                             fontSize: 14, textColor: .black, textAlignment: .center)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: kSuperViewMargin),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin)
        ])
    }
    
    private func addSubTitleView() {
        phoneNumberLabel.labelTheme = RegularTheme(label: Preferences.getPrefsUser()?.phoneNumber ?? "",
                                                fontSize: 14, textColor: .black, textAlignment: .right)
        wrongNumberButton.buttonTheme = BaseTheme(label: LocalizedConstants.wrong_number_key.localized,
                                               underLine: true, titleColor: .primary, contentHorizontalAlignment: .left)
        
        subTitleView.addSubview(phoneNumberLabel)
        subTitleView.addSubview(wrongNumberButton)
    
        NSLayoutConstraint.activate([
            phoneNumberLabel.centerYAnchor.constraint(equalTo: subTitleView.centerYAnchor),
            wrongNumberButton.centerYAnchor.constraint(equalTo: subTitleView.centerYAnchor),
            phoneNumberLabel.leftAnchor.constraint(equalTo: subTitleView.leftAnchor),
            phoneNumberLabel.rightAnchor.constraint(equalTo: wrongNumberButton.leftAnchor, constant: -kSpaceBetweenElements),
            wrongNumberButton.rightAnchor.constraint(equalTo: subTitleView.rightAnchor),
            subTitleView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: kSuperViewMargin),
            subTitleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            subTitleView.heightAnchor.constraint(equalToConstant: kSuperViewMargin)
        ])
    }
    
    private func addOTPLabel() {
        otpLabel.labelTheme = RegularTheme(label: LocalizedConstants.six_digit_code_key.localized,
                                                    fontSize: 20, textColor: .black, textAlignment: .center)
        NSLayoutConstraint.activate([
            otpLabel.topAnchor.constraint(equalTo: wrongNumberButton.bottomAnchor, constant: kSuperViewMargin*2),
            otpLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func addOTPView() {
        otpView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            otpView.heightAnchor.constraint(equalToConstant: 44.0),
            otpView.topAnchor.constraint(equalTo: otpLabel.bottomAnchor, constant: kSuperViewMargin*2),
            otpView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        otpView.addSubview(otpStackView)
        otpStackView.translatesAutoresizingMaskIntoConstraints = false
        otpStackView.heightAnchor.constraint(equalTo: otpView.heightAnchor).isActive = true
        otpStackView.centerXAnchor.constraint(equalTo: otpView.centerXAnchor).isActive = true
        otpStackView.centerYAnchor.constraint(equalTo: otpView.centerYAnchor).isActive = true
    }
    
    private func addCountDownLabel() {
       countDownLabel.labelTheme = RegularTheme(label: "", fontSize: 10, textColor: .black, textAlignment: .center)
       NSLayoutConstraint.activate([
           countDownLabel.topAnchor.constraint(equalTo: otpView.bottomAnchor, constant: kSuperViewMargin),
           countDownLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
       ])
   }

    private func addCenterButtons() {
        resendSMSButton.buttonTheme = BaseTheme(label: LocalizedConstants.resend_sms_key.localized,
                                                titleColor: .primary, contentHorizontalAlignment: .left)
        activateByCallButton.buttonTheme = BaseTheme(label: LocalizedConstants.activate_by_call_key.localized,
                                                     titleColor: .primary, contentHorizontalAlignment: .right)
            
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
    
        stackView.addArrangedSubview(resendSMSButton)
        stackView.addArrangedSubview(activateByCallButton)
          
        self.addSubview(stackView)
          
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: countDownLabel.bottomAnchor, constant: kSuperViewMargin*4).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin).isActive = true
    }

    private func addFinishButton() {
        finishButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.finish_key.localized)
        NSLayoutConstraint.activate([
            finishButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin*2),
            finishButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin*2),
            finishButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -kSuperViewMargin*2)
        ])
    }
    
    // MARK: - Public Interface
    func updateCountDownLabel(time: Double) {
        countDownLabel.text = String(time)
    }
}

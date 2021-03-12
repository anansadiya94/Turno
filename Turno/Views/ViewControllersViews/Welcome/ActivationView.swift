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
    @UseAutoLayout var oneTimeCodeLabel = CustomLabel()
    @UseAutoLayout var countDownLabel = CustomLabel()
    @UseAutoLayout var resendSMSButton = CustomButton()
    @UseAutoLayout var oneTimeCodeTextField = OneTimeCodeTextField()
    
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
        addOneTimeCodeLabel()
        addOneTimeCodeView()
        addCountDownLabel()
        addResendSMSButton()
    }
    
    private func addSubviews() {
        self.addSubview(progressView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleView)
        self.addSubview(oneTimeCodeLabel)
        self.addSubview(oneTimeCodeTextField)
        self.addSubview(countDownLabel)
        self.addSubview(resendSMSButton)
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
    
    private func addOneTimeCodeLabel() {
        oneTimeCodeLabel.labelTheme = RegularTheme(label: LocalizedConstants.six_digit_code_key.localized,
                                           fontSize: 20, textColor: .black, textAlignment: .center)
        NSLayoutConstraint.activate([
            oneTimeCodeLabel.topAnchor.constraint(equalTo: wrongNumberButton.bottomAnchor, constant: kSuperViewMargin*2),
            oneTimeCodeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func addOneTimeCodeView() {
        NSLayoutConstraint.activate([
            oneTimeCodeTextField.heightAnchor.constraint(equalToConstant: 44.0),
            oneTimeCodeTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            oneTimeCodeTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin),
            oneTimeCodeTextField.topAnchor.constraint(equalTo: oneTimeCodeLabel.bottomAnchor, constant: kSuperViewMargin*2),
            oneTimeCodeTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func addCountDownLabel() {
        countDownLabel.labelTheme = RegularTheme(label: "", fontSize: 10, textColor: .black, textAlignment: .center)
        NSLayoutConstraint.activate([
            countDownLabel.topAnchor.constraint(equalTo: oneTimeCodeTextField.bottomAnchor, constant: kSuperViewMargin),
            countDownLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func addResendSMSButton() {
        resendSMSButton.buttonTheme = BaseTheme(label: LocalizedConstants.resend_sms_key.localized,
                                                titleColor: .primary, contentHorizontalAlignment: .left, isEnabled: false)
        NSLayoutConstraint.activate([
            resendSMSButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            resendSMSButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    // MARK: - Public Interface
    func updateCountDownLabel(time: Double) {
        let duration: TimeInterval = time
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second ]
        formatter.zeroFormattingBehavior = [.pad]
        let formattedDuration = formatter.string(from: duration)
        
        countDownLabel.text = formattedDuration
    }
    
    func isResendSMSButtonEnabled(_ isEnabled: Bool) {
        resendSMSButton.isEnabled = isEnabled
    }
}

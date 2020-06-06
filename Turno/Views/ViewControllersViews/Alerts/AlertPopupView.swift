//
//  AlertPopupView.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class AlertPopupView: UIView {
    
    // MARK: - Properties
    @UseAutoLayout var alertView = UIView()
    @UseAutoLayout var alertTitle = CustomLabel()
    @UseAutoLayout var alertMessage = CustomLabel()
    @UseAutoLayout var alertButton1 = RoundedCustomButton()
    @UseAutoLayout var alertButton2 = RoundedCustomButton()
    
    // MARK: - Constraints constants
    private var kSuperViewLeftRightMargin: CGFloat = 64
    private var kSuperViewMargin: CGFloat = 16
    private var kLeftRightBottomMargin: CGFloat = 16
    private var kButtonHeightAnchor: CGFloat = 44
    
    // MARK: - UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .overlay
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func configureUI() {
        addSubviews()
        addAlertView()
        addAlertTitle()
        addAlertMessage()
        addAlertButtons()
    }

    private func addSubviews() {
        self.addSubview(alertView)
        self.addSubview(alertTitle)
        self.addSubview(alertMessage)
        self.addSubview(alertButton1)
        self.addSubview(alertButton2)
    }
    
    private func addAlertView() {
        alertView.layer.cornerRadius = 5
        alertView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            alertView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewLeftRightMargin),
            alertView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewLeftRightMargin),
            alertView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func addAlertTitle() {
        alertTitle.labelTheme = RegularTheme(label: "", fontSize: 20, textColor: .black, textAlignment: .center)
        NSLayoutConstraint.activate([
            alertTitle.topAnchor.constraint(equalTo: alertView.topAnchor, constant: kSuperViewMargin),
            alertTitle.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: kLeftRightBottomMargin),
            alertTitle.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -kLeftRightBottomMargin),
            alertTitle.bottomAnchor.constraint(equalTo: alertMessage.topAnchor, constant: -kSuperViewMargin)
        ])
    }
    
    private func addAlertMessage() {
        alertMessage.labelTheme = SemiBoldTheme(label: "", fontSize: 18, textColor: .black, textAlignment: .center)
        NSLayoutConstraint.activate([
            alertMessage.topAnchor.constraint(equalTo: alertTitle.bottomAnchor, constant: kSuperViewMargin),
            alertMessage.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: kLeftRightBottomMargin),
            alertMessage.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -kLeftRightBottomMargin),
            alertMessage.centerYAnchor.constraint(equalTo: alertView.centerYAnchor)
        ])
    }
    
    private func addAlertButtons() {
        alertButton1.buttonTheme = RoundedBaseTheme(label: "")
        alertButton2.buttonTheme = RoundedBaseTheme(label: "")
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
    
        stackView.addArrangedSubview(alertButton1)
        stackView.addArrangedSubview(alertButton2)
          
        self.addSubview(stackView)
          
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: alertMessage.bottomAnchor, constant: kSuperViewMargin*2).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: kButtonHeightAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: kLeftRightBottomMargin).isActive = true
        stackView.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -kLeftRightBottomMargin).isActive = true
        stackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -kSuperViewMargin).isActive = true
    }
    
    func setAlertDataView(modelAlertPopup: ModelAlertPopup) {
        self.alertTitle.text = modelAlertPopup.title ?? ""
        self.alertMessage.text = modelAlertPopup.message ?? ""
        self.alertButton1.setTitle(modelAlertPopup.action1 ?? "", for: .normal)
        self.alertButton2.setTitle(modelAlertPopup.action2 ?? "", for: .normal)
    }
}

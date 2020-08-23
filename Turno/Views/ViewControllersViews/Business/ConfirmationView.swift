//
//  ConfirmationView.swift
//  Turno
//
//  Created by Anan Sadiya on 23/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class ConfirmationView: UIView {
    
    // MARK: - Properties
    @UseAutoLayout var dayLabel = CustomLabel()
    @UseAutoLayout var startTimeLabel = CustomLabel()
    @UseAutoLayout var endTimeLabel = CustomLabel()
    @UseAutoLayout var confirmMessageLabel = CustomLabel()
    @UseAutoLayout var confitmButton = RoundedCustomButton()
    
    // MARK: - UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        createConfirmNowButton()
        createConfirmMessageLabel()
        createHeaderStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    func createConfirmNowButton() {
        addSubview(confitmButton)
        confitmButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.confirm_key.localized)
        
        NSLayoutConstraint.activate([
            confitmButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            confitmButton.heightAnchor.constraint(equalToConstant: 44.0),
            confitmButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 32.0),
            confitmButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -32.0)
        ])
    }
    
    func createConfirmMessageLabel() {
        addSubview(confirmMessageLabel)
        confirmMessageLabel.labelTheme = Lightheme(label: LocalizedConstants.confirm_message_key.localized,
                                                   fontSize: 18, textColor: .black, textAlignment: .center,
                                                   numberOfLines: 3, adjustsFontSizeToFitWidth: true)
        
        NSLayoutConstraint.activate([
            confirmMessageLabel.bottomAnchor.constraint(equalTo: confitmButton.topAnchor, constant: -16.0),
            confirmMessageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            confirmMessageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0)
        ])
    }
    
    func createHeaderStackView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        
        let dayTitleLabel = CustomLabel()
        dayTitleLabel.labelTheme = BoldTheme(label: "Day", fontSize: 20,
                                             textColor: .black, textAlignment: .center)
        let dayStackView = UIStackView()
        dayStackView.axis = .vertical
        dayStackView.distribution = .fillEqually
        dayStackView.alignment = .fill
        dayStackView.spacing = 4
        dayStackView.addArrangedSubview(dayTitleLabel)
        dayStackView.addArrangedSubview(dayLabel)
        
        let startTimeTitleLabel = CustomLabel()
        startTimeTitleLabel.labelTheme = BoldTheme(label: "Start time", fontSize: 20,
                                             textColor: .black, textAlignment: .center)
        let startTimeStackView = UIStackView()
        startTimeStackView.axis = .vertical
        startTimeStackView.distribution = .fillEqually
        startTimeStackView.alignment = .fill
        startTimeStackView.spacing = 4
        startTimeStackView.addArrangedSubview(startTimeTitleLabel)
        startTimeStackView.addArrangedSubview(startTimeLabel)
        
        let endTimeTitleLabel = CustomLabel()
        endTimeTitleLabel.labelTheme = BoldTheme(label: "End time", fontSize: 20,
                                             textColor: .black, textAlignment: .center)
        let endTimeStackView = UIStackView()
        endTimeStackView.axis = .vertical
        endTimeStackView.distribution = .fillEqually
        endTimeStackView.alignment = .fill
        endTimeStackView.spacing = 4
        endTimeStackView.addArrangedSubview(endTimeTitleLabel)
        endTimeStackView.addArrangedSubview(endTimeLabel)
        
        stackView.addArrangedSubview(dayStackView)
        stackView.addArrangedSubview(startTimeStackView)
        stackView.addArrangedSubview(endTimeStackView)
        
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
    }
    
    // MARK: - Public Interface
    func setHeaderStackViewData(day: String?, startTime: String?, endTime: String?) {
        dayLabel.labelTheme = RegularTheme(label: day ?? "", fontSize: 18, textColor: .black,
                                           textAlignment: .center)
        startTimeLabel.labelTheme = RegularTheme(label: startTime ?? "", fontSize: 18, textColor: .black,
                                                 textAlignment: .center)
        endTimeLabel.labelTheme = RegularTheme(label: endTime ?? "", fontSize: 18, textColor: .black,
                                               textAlignment: .center)
    }
}

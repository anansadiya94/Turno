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
    @UseAutoLayout var finishButton = RoundedCustomButtonWithMargin()
    
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
        addFinishButton()
    }

    func addSubviews() {
        self.addSubview(finishButton)
    }

    private func addFinishButton() {
        finishButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.finish_key.localized)
        NSLayoutConstraint.activate([
            finishButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin*2),
            finishButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin*2),
            finishButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -kSuperViewMargin*2)
        ])
    }
}

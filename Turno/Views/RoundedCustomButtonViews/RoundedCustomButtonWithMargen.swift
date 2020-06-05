//
//  RoundedCustomButtonWithMargen.swift
//  Turno
//
//  Created by Anan Sadiya on 05/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class RoundedCustomButtonWithMargin: RoundedCustomButton {
    
    @UseAutoLayout var buttonTitle = UILabel()
    
    private var kSuperViewMargin: CGFloat = 16
    
    override var buttonTheme: RoundedCustomButtonTheme? {
        didSet {
            setupStyle()
        }
    }
    
    private func setupStyle() {
        setTitle(nil, for: .normal)
        buttonTitle.text = buttonTheme?.label
        buttonTitle.textColor = buttonTheme?.titleColor
        buttonTitle.font = buttonTheme?.font
        setup()
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setup() {
        buttonTitle.textAlignment = .center
        addSubview(buttonTitle)
        NSLayoutConstraint.activate([
            buttonTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: kSuperViewMargin),
            buttonTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -kSuperViewMargin),
            buttonTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

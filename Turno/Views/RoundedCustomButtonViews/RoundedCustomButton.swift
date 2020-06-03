//
//  RoundedCustomButton.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class RoundedCustomButton: UIButton {
    
    var buttonTheme: RoundedCustomButtonTheme? {
        didSet {
            setupStyle()
        }
    }
    
    private func setupStyle() {
        if let buttonTheme = buttonTheme {
            backgroundColor = buttonTheme.backgroundColor
            setTitle(buttonTheme.label, for: .normal)
            setTitleColor(buttonTheme.titleColor, for: .normal)
            layer.borderColor = buttonTheme.borderColor
            titleLabel?.font = buttonTheme.font
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 20
        layer.borderWidth = 1
        titleLabel?.font = Fonts.Bold14
    }
}

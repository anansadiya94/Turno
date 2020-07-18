//
//  CustomButton.swift
//  Turno
//
//  Created by Anan Sadiya on 04/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    var buttonTheme: CustomButtonTheme? {
        didSet {
            setupStyle()
        }
    }
    
    private func setupStyle() {
        if let buttonTheme = buttonTheme {
            setTitle(buttonTheme.label, for: .normal)
            setTitleColor(buttonTheme.titleColor, for: .normal)
            titleLabel?.font = buttonTheme.font
            buttonTheme.underLine ? underline() : Void()
            contentHorizontalAlignment = buttonTheme.contentHorizontalAlignment
            isEnabled = buttonTheme.isEnabled
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
        titleLabel?.numberOfLines = 0
    }
    
    override public var isEnabled: Bool {
        didSet {
            setTitleColor(isEnabled ? .primary : .gray, for: .normal)
        }
    }
}

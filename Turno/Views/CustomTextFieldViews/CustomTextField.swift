//
//  CustomTextField.swift
//  Turno
//
//  Created by Anan Sadiya on 05/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    var textFieldTheme: CustomTextFieldTheme? {
        didSet {
            setupStyle()
        }
    }
    
    private func setupStyle() {
        if let textFieldTheme = textFieldTheme {
            textColor = textFieldTheme.textColor
            attributedPlaceholder = NSAttributedString(string: textFieldTheme.placeholder,
                                                       attributes: [NSAttributedString.Key.foregroundColor: textFieldTheme.textColor])
            textContentType = textFieldTheme.textContentType
            keyboardType = textFieldTheme.keyboardType
            returnKeyType = textFieldTheme.returnKeyType
            setLeftView(image: textFieldTheme.icon)
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
        font = Fonts.Regular12
        borderStyle = .roundedRect
        autocorrectionType = .no
        clearButtonMode = .whileEditing
        contentVerticalAlignment = .center
        layer.borderWidth = 2
        layer.borderColor = UIColor.overlay.cgColor
        layer.cornerRadius = 5
    }
    
    private func setLeftView(image: String) {
        self.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        let image = UIImage(named: image)
        imageView.image = image
        self.leftView = imageView
    }
}

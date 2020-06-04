//
//  UIButton+Underline.swift
//  Turno
//
//  Created by Anan Sadiya on 04/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

extension UIButton {
    func underline() {
        guard let buttonTitle = self.titleLabel?.text else { return }
        self.titleLabel?.attributedText = NSAttributedString(string: buttonTitle, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
}

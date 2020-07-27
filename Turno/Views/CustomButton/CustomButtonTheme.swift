//
//  CustomButtonTheme.swift
//  Turno
//
//  Created by Anan Sadiya on 04/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

protocol CustomButtonTheme {
    var label: String {get set}
    var backgroundColor: UIColor {get}
    var titleColor: UIColor {get}
    var font: UIFont? {get set}
    var underLine: Bool {get set}
    var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment {get}
    var isEnabled: Bool {get set}
}

struct BaseTheme: CustomButtonTheme {
    var underLine: Bool = false
    var font: UIFont? = Fonts.Regular15
    var label: String
    var backgroundColor: UIColor = .clear
    var titleColor: UIColor = .black
    var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .center
    var isEnabled: Bool = true
    
    init(label: String, underLine: Bool = false, titleColor: UIColor = .black, contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .center, isEnabled: Bool = true) {
        self.label = label.localized
        self.underLine = underLine
        self.titleColor = titleColor
        self.contentHorizontalAlignment = contentHorizontalAlignment
        self.isEnabled = isEnabled
    }
}

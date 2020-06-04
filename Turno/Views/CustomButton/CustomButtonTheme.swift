//
//  CustomButtonTheme.swift
//  Turno
//
//  Created by Anan Sadiya on 04/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

protocol CustomButtonTheme {
    var label: String {get set}
    var backgroundColor: UIColor {get}
    var titleColor: UIColor {get}
    var font: UIFont? {get set}
    var underLine: Bool {get set}
    var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment {get}
}

struct BaseTheme: CustomButtonTheme {
    var underLine: Bool = false
    var font: UIFont? = Fonts.Regular15
    var label: String
    var backgroundColor: UIColor = .clear
    var titleColor: UIColor = .black
    var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .center

    init(label: String, underLine: Bool = false) {
        self.label = label.localized
        self.underLine = underLine
    }
}

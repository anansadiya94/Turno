//
//  RoundedCustomButtonThemes.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

protocol RoundedCustomButtonTheme {
    var label: String {get set}
    var backgroundColor: UIColor {get}
    var titleColor: UIColor {get}
    var buttonImageName: String? {get set}
    var borderColor: CGColor? {get}
    var font: UIFont {get}
    var label2: String? {get set}
    var button2ImageName: String? {get set}
    var isBlurBackground: Bool {get}
}

struct OnboardingTheme: RoundedCustomButtonTheme {
    var borderColor: CGColor? = UIColor.primary.cgColor
    var buttonImageName: String?
    var label: String
    var backgroundColor: UIColor = .primary
    var titleColor: UIColor = .black
    var font: UIFont = Fonts.Bold14
    var label2: String?
    var button2ImageName: String?
    var isBlurBackground: Bool = false
    
    init(label: String, isLast: Bool) {
        self.label = label.localized
        self.backgroundColor = isLast ? .primary : .white
        self.titleColor = isLast ? .white : .primary
    }
}

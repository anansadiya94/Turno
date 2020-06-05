//
//  CustomTextFieldThemes.swift
//  Turno
//
//  Created by Anan Sadiya on 05/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

protocol CustomTextFieldTheme {
    var placeholder: String {get set}
    var textColor: UIColor {get set}
    var textContentType: UITextContentType {get}
    var keyboardType: UIKeyboardType {get}
    var icon: String {get}
}

struct NameTheme: CustomTextFieldTheme {
    var textColor: UIColor  = .black
    var placeholder: String
    var textContentType: UITextContentType = .name
    var keyboardType: UIKeyboardType = .default
    var icon: String
    
    init(placeholder: String, icon: String) {
        self.placeholder = placeholder.localized
        self.icon = icon
    }
}

struct PhoneNumberTheme: CustomTextFieldTheme {
    var textColor: UIColor  = .black
    var placeholder: String
    var textContentType: UITextContentType = .telephoneNumber
    var keyboardType: UIKeyboardType = .phonePad
    var icon: String

    init(placeholder: String, icon: String) {
        self.placeholder = placeholder.localized
        self.icon = icon
    }
}

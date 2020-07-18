//
//  CustomTextFieldThemes.swift
//  Turno
//
//  Created by Anan Sadiya on 05/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

protocol CustomTextFieldTheme {
    var placeholder: String {get set}
    var textColor: UIColor {get set}
    var textContentType: UITextContentType {get}
    var keyboardType: UIKeyboardType {get}
    var icon: String {get}
    var returnKeyType: UIReturnKeyType {get}
}

struct NameTheme: CustomTextFieldTheme {
    var textColor: UIColor  = .black
    var placeholder: String
    var textContentType: UITextContentType = .name
    var keyboardType: UIKeyboardType = .default
    var icon: String
    var returnKeyType: UIReturnKeyType
    
    init(placeholder: String, icon: String, returnKeyType: UIReturnKeyType) {
        self.placeholder = placeholder.localized
        self.icon = icon
        self.returnKeyType = returnKeyType
    }
}

struct PhoneNumberTheme: CustomTextFieldTheme {
    var textColor: UIColor  = .black
    var placeholder: String
    var textContentType: UITextContentType = .telephoneNumber
    var keyboardType: UIKeyboardType = .phonePad
    var icon: String
    var returnKeyType: UIReturnKeyType
    
    init(placeholder: String, icon: String, returnKeyType: UIReturnKeyType) {
        self.placeholder = placeholder.localized
        self.icon = icon
        self.returnKeyType = returnKeyType
    }
}

//
//  ServiceTextFieldValidation.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

enum TextFieldErrorType: String {
    case valid
    case empty_field_key
    case invalid_name_key
    case invalid_phoneNumber_key
}

class ServiceTextFieldValidation {
    // MARK: - Public Interface
    static func validateName(_ text: String?) -> TextFieldErrorType {
        guard let name = text, name.isEmpty == false else { return .empty_field_key }
        let nameRegEx = "^[A-zÀ-ú\\u0621-\\u064A\\u0590-\\u05fe\\u0400-\\u04ff ]{2,30}$"
        let namePred = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name) ? .valid : .invalid_name_key
    }
    
    static func validatePhoneNumber(_ text: String?) -> TextFieldErrorType {
        guard let phoneNumber = text, phoneNumber.isEmpty == false else { return .empty_field_key }
        let nameRegEx = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
        let namePred = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: phoneNumber) ? .valid : .invalid_phoneNumber_key
    }
}

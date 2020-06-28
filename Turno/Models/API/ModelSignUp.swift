//
//  ModelSignUp.swift
//  Turno
//
//  Created by Anan Sadiya on 13/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

typealias Codable = Encodable & Decodable

struct ModelSignUpTask: Codable {
    
    var phoneNumber: String
    var fullName: String
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber, fullName
    }
}

struct ModelSignUp: Codable {
    
    var nextOption: String?
    var remainingTimeInSeconds: Int?
    var title: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case nextOption, remainingTimeInSeconds, title, message
    }
}

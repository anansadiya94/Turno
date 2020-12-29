//
//  ModelVerify.swift
//  Turno
//
//  Created by Anan Sadiya on 13/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct ModelVerifyTask: Codable {
    var phoneNumber: String
    var verificationCode: String
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber, verificationCode
    }
}

struct ModelVerify: Codable, ModelApiError {
    var secret: String?
    var userId: String?
    var businessId: String?
    var title: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case secret, userId, businessId, title, message
    }
}

//
//  ModelVerify.swift
//  Turno
//
//  Created by Anan Sadiya on 13/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct ModelVerify: Codable {
    
    var phoneNumber: String
    var verificationCode: String
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber, verificationCode
    }
}

struct ModelVerifyResponse: Codable {
    
    var secret: String?
    var userId: String?
    var title: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case secret, userId, title, message
    }
}

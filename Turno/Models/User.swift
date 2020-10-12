//
//  User.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct User: Codable {
    var secret: String?
    var userId: String?
    var businessId: String?
    var name: String?
    var phoneNumber: String?
    
    init(secret: String? = nil,
         userId: String? = nil,
         businessId: String? = nil,
         name: String? = nil,
         phoneNumber: String? = nil) {
        self.secret = secret
        self.userId = userId
        self.businessId = businessId
        self.name = name
        self.phoneNumber = phoneNumber
    }
}

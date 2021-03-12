//
//  ModelBlockedUsers.swift
//  Turno
//
//  Created by Anan Sadiya on 30/12/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct ModelBlockedUser: Codable {
    let userId: String?
    let fullName: String?
    let phoneNumber: String?
}

struct ModelBlockUser: Codable {
    let userId: String?
    let phoneNumber: String?
    
    init(userId: String? = nil, phoneNumber: String? = nil) {
        self.userId = userId
        self.phoneNumber = phoneNumber
    }
}
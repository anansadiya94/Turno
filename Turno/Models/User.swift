//
//  User.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct User: Codable {
    let token: String?
    let name: String?
    let phoneNumber: String?
    
    init(token: String? = nil, name: String? = nil, phoneNumber: String? = nil) {
        self.token = token
        self.name = name
        self.phoneNumber = phoneNumber
    }
}

//
//  Customer.swift
//  Turno
//
//  Created by Anan Sadiya on 01/11/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct Customer: Codable {
    var name: String?
    var phoneNumber: String?
    
    init(name: String? = nil,
         phoneNumber: String? = nil) {
        self.name = name
        self.phoneNumber = phoneNumber
    }
}

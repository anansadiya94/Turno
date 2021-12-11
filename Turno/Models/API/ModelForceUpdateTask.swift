//
//  ModelForceUpdate.swift
//  Turno
//
//  Created by Anan Sadiya on 11/12/2021.
//  Copyright © 2021 Anan Sadiya. All rights reserved.
//

import Foundation

struct ModelForceUpdateTask: Codable {
    let currentVersion: String
    let osType: Int
}

struct ModelForceUpdate: Codable {
    let shouldForceUpdate: Bool
    
    enum CodingKeys: String, CodingKey {
        case shouldForceUpdate = "ShouldForceUpdate"
    }
}

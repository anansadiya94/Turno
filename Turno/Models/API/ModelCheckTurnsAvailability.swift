//
//  ModelCheckTurnsAvailability.swift
//  Turno
//
//  Created by Anan Sadiya on 09/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct ModelCheckTurnsAvailabilityTask: Codable {
    var services: [Service]?
    
    enum CodingKeys: String, CodingKey {
        case services
    }
}

struct ModelCheckTurnsAvailability: Codable {
    var availableTurns: [AvailableTurn]?
    
    enum CodingKeys: String, CodingKey {
        case availableTurns = "AvailableTurns"
    }
}

struct AvailableTurn: Codable {
    var services: [Service]?
    var dateOfService: String?
    var dayOfService: String?
    var emptySlots: [EmptySlot]?
    
    enum CodingKeys: String, CodingKey {
        case services = "Services"
        case dateOfService = "DateOfService"
        case dayOfService = "DayOfService"
        case emptySlots = "EmptySlots"
    }
}

struct EmptySlot: Codable {
    var turnId: String?
    var dateTimeUTC: String?
    var services: [Service]?
    
    enum CodingKeys: String, CodingKey {
        case turnId, dateTimeUTC, services
    }
}

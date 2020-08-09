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

class EmptySlot: Codable {
    var turnId: String?
    var dateTimeUTC: String?
    var services: [Service]?
    var selected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case turnId, dateTimeUTC, services
    }
    
    init(turnId: String? = nil, dateTimeUTC: String? = nil, services: [Service]? = nil, selected: Bool = false) {
        self.turnId = turnId
        self.dateTimeUTC = dateTimeUTC
        self.services = services
        self.selected = selected
    }
}

class ModelAvailableTurnDay {
    let day: String?
    let date: String?
    var selected: Bool?
    
    init(day: String? = nil, date: String? = nil, selected: Bool? = nil) {
        self.day = day
        self.date = date
        self.selected = selected
    }
}

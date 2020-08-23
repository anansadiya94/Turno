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
}

struct ModelCheckTurnsAvailability: Codable {
    let availableDates: [String: [String]]?
    
    init(availableDates: [String: [String]]? = nil) {
        self.availableDates = availableDates
    }
}

class EmptySlot {
    var slot: String?
    var selected: Bool = false
    
    init(slot: String? = nil, selected: Bool = false) {
        self.slot = slot
        self.selected = selected
    }
}

class ModelAvailableTurnDay {
    let date: String?
    var selected: Bool?
    
    init(date: String? = nil, selected: Bool? = nil) {
        self.date = date
        self.selected = selected
    }
}

struct ModelBookTask: Codable {
    var servicesToBook: [Service]?
    var dateTime: String?
}

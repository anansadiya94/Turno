//
//  ModelCheckTurnsAvailability.swift
//  Turno
//
//  Created by Anan Sadiya on 09/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct ModelCheckTurnsAvailabilityTask: Codable {
    var servicesToBook: [ServiceToBook]?
}

struct ServiceToBook: Codable {
    var identifier: String?
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case count
        case identifier = "id"
    }
}

struct ModelCheckTurnsAvailability: Codable, ModelApiError {
    let availableDates: [String: [String]]?
    var title: String?
    var message: String?
    
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
    var servicesToBook: [ServiceToBook]?
    var dateTime: String?
}

struct ModelBookByBusinessTask: Codable {
    var servicesToBook: [ServiceToBook]?
    var dateTime: String?
    var phoneNumber: String?
    var fullName: String?
}

struct ModelMyBookingTask: Codable {
    var lastStatusCheck: String?
}

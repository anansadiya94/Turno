//
//  ModelBusiness.swift
//  Turno
//
//  Created by Anan Sadiya on 24/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct ModelBusinessTask: Codable {
    
    var query: String?
    var longitude: Double?
    var latitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case query, longitude, latitude
    }
    
    init(query: String? = nil, longitude: Double? = nil, latitude: Double? = nil) {
        self.query = query
        self.longitude = longitude
        self.latitude = latitude
    }
}

struct ModelBusiness: Codable, ModelApiError {
    
    var identifier: String?
    var name: String?
    var image: String?
    var address: String?
    var description: String?
    var longitude: Double?
    var latitude: Double?
    var ownerName: String?
    var phone: String?
    var isFavorite: Bool?
    var services: [Service]?
    var turns: [Turn]?
    var email: String?
    let openingHours: [OpeningHour]?
    var title: String?
    var message: String?
    
    var openingHoursDescription: String {
        let prefLanguage = Locale.current.languageCode ?? "en"
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: prefLanguage)
        let weekdays = calendar.weekdaySymbols
        
        var description = ""
        
        guard let openingHours = openingHours else { return "N/A" }
        
        for (index, openingHour) in openingHours.enumerated() {
            if let day = openingHour.day,
               let startTime = openingHour.startTime,
               let startTimeToShow = startTime.toString().toDisplayableDate(type: .hour),
               let endTime = openingHour.endTime,
               let endTimeToShow = endTime.toString().toDisplayableDate(type: .hour) {
                description.append("\(weekdays[day-1]): \(startTimeToShow) - \(endTimeToShow)")
                if index != openingHours.count - 1 {
                    description.append("\n")
                }
            }
        }
        return description
    }
    
    enum CodingKeys: String, CodingKey {
        case name, address, longitude, latitude, ownerName, isFavorite, services, turns, email, openingHours, title, message
        case identifier = "id"
        case image = "imageUri"
        case description = "businessDescription"
        case phone = "phone"
    }
    
    init(identifier: String? = nil, name: String? = nil, image: String? = nil,
         address: String? = nil, description: String? = nil, longitude: Double? = nil,
         latitude: Double? = nil, ownerName: String? = nil, phone: String? = nil,
         isFavorite: Bool? = nil, turns: [Turn]? = nil, services: [Service]? = nil,
         openingHours: [OpeningHour]? = nil) {
        self.identifier = identifier
        self.name = name
        self.image = image
        self.address = address
        self.description = description
        self.longitude = longitude
        self.latitude = latitude
        self.ownerName = ownerName
        self.phone = phone
        self.isFavorite = isFavorite
        self.turns = turns
        self.services = services
        self.openingHours = openingHours
    }
    
    mutating func isFavoriteTapped() {
        if let isFavorite = isFavorite {
            self.isFavorite = !isFavorite
        }
    }
}

struct OpeningHour: Codable {
    let day: Int?
    let startTime, endTime: Date?
}

struct Turn: Codable, ModelApiError {
    var identifier: String?
    var dateTimeUTC: Date?
    var userName: String?
    var userPhone: String?
    var userId: String?
    var services: [Service]?
    var title: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case dateTimeUTC, userName, userPhone, userId, services, title, message
        case identifier = "turnId"
    }
}

class Service: Codable {
    var identifier: String?
    var serviceName: String?
    var durationInMinutes: Int?
    var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case serviceName, durationInMinutes, count
        case identifier = "serviceId"
    }
    
    init(identifier: String? = nil, serviceName: String? = nil,
         durationInMinutes: Int? = nil, count: Int? = nil) {
        self.identifier = identifier
        self.serviceName = serviceName
        self.durationInMinutes = durationInMinutes
        self.count = count
    }
}

struct ModelFavoritesTask: Codable {
    var businessId: String?
    
    enum CodingKeys: String, CodingKey {
        case businessId
    }
}

struct ModelAppointment {
    var identifier: String?
    var name: String?
    var image: String?
    var address: String?
    var turn: Turn?
    var phone: String?
}

struct ModelModifyService {
    var identifier: String
    var count: Int
}

struct ModelLocation {
    let name: String
    let location: Location
}

struct Location {
    var lat: Double?
    var lng: Double?
}

struct ModelCancelTurnTask: Codable {
    var turnId: String?
    
    enum CodingKeys: String, CodingKey {
        case turnId
    }
}

struct ModelMyBookings: Codable, ModelApiError {
    let myBookings: [String: [Turn]]?
    var title: String?
    var message: String?
    
    init(myBookings: [String: [Turn]]? = nil) {
        self.myBookings = myBookings
    }
}

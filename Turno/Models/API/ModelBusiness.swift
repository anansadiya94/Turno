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

struct ModelBusiness: Codable {
    
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
    
    enum CodingKeys: String, CodingKey {
        case name, address, longitude, latitude, ownerName, isFavorite
        case identifier = "id"
        case image = "imageUri"
        case description = "businessDescription"
        case phone = "Phone"
    }
    
    init(identifier: String? = nil, name: String? = nil, image: String? = nil,
         address: String? = nil, description: String? = nil, longitude: Double? = nil,
         latitude: Double? = nil, ownerName: String? = nil, phone: String? = nil,
         isFavorite: Bool? = nil) {
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
    }
    
    mutating func isFavoriteTapped() {
        if let isFavorite = isFavorite {
            self.isFavorite = !isFavorite
        }
    }
}

struct ModelFavoritesTask: Codable {

    var businessId: String?
    
    enum CodingKeys: String, CodingKey {
        case businessId
    }
}

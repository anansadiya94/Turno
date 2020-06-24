//
//  ModelBusiness.swift
//  Turno
//
//  Created by Anan Sadiya on 24/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct ModelBusiness: Codable {
    
    var identifier: String?
    var image: String?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case identifier, image, name
    }
}

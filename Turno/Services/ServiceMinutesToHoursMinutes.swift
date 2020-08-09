//
//  ServiceMinutesToHoursMinutes.swift
//  Turno
//
//  Created by Anan Sadiya on 09/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class ServiceMinutesToHoursMinutes {
    
    static func minutesToHoursMinutes (bookedServices: [Service]?) -> (hours: Int, leftMinutes: Int) {
        guard let bookedServices = bookedServices else { return (0, 0)}
        var total: Int = 0
        bookedServices.forEach({
            if let count = $0.count, let durationInMinutes = $0.durationInMinutes {
                total += count * durationInMinutes
            }
        })
        return (total / 60, (total % 60))
    }
}

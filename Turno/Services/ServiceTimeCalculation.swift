//
//  ServiceTimeCalculation.swift
//  Turno
//
//  Created by Anan Sadiya on 09/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class ServiceTimeCalculation {
    
    static func minutesToHoursMinutes(bookedServices: [Service]?) -> (hours: Int, leftMinutes: Int) {
        guard let bookedServices = bookedServices else { return (0, 0) }
        
        var total: Int = 0
        
        bookedServices.forEach({
            if let count = $0.count, let durationInMinutes = $0.durationInMinutes {
                total += count * durationInMinutes
            }
        })
        
        return (total / 60, (total % 60))
    }
    
    static func calculateDuration(to bookedServices: [Service]?) -> Int {
        var duration = 0
        
        guard let bookedServices = bookedServices else { return duration }
        
        bookedServices.forEach({
            if let count = $0.count, let durationInMinutes = $0.durationInMinutes {
                duration += (count * durationInMinutes)
            }
        })
        
        return duration
    }
}

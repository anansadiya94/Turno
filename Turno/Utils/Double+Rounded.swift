//
//  Double+Rounde.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

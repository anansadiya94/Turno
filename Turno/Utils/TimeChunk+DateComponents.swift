//
//  TimeChunk+DateComponents.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import DateToolsSwift

extension TimeChunk {
  static func dateComponents(seconds: Int = 0,
                             minutes: Int = 0,
                             hours: Int = 0,
                             days: Int = 0,
                             weeks: Int = 0,
                             months: Int = 0,
                             years: Int = 0) -> TimeChunk {
    return TimeChunk(seconds: seconds,
                     minutes: minutes,
                     hours: hours,
                     days: days,
                     weeks: weeks,
                     months: months,
                     years: years)
  }
}

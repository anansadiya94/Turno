//
//  String+Localized.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

enum DisplayableDateType {
    case dateAndHour
    case date
    case hour
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: self)
    }
    
    static func fromDateAndHour(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy HH:mm"
        return df.string(from: date)
    }
    
    static func fromDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        return df.string(from: date)
    }
    
    static func fromHout(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df.string(from: date)
    }
    
    func toDisplayableDate(type: DisplayableDateType) -> String? {
        if let date = self.toDate() {
            switch type {
            case .dateAndHour:
                return String.fromDateAndHour(date)
            case .date:
                return String.fromDate(date)
            case .hour:
                return String.fromHout(date)
            }
        }
        return nil
    }
}

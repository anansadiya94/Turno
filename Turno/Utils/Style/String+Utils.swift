//
//  String+Localized.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: self)
    }
    
    static func fromDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy HH:mm"
        return df.string(from: date)
    }
    
    func toDisplayableDate() -> String? {
        if let date = self.toDate() {
            return String.fromDate(date)
        }
        return nil
    }
}

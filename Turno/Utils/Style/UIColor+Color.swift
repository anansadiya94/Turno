//
//  UIColor+Color.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

extension UIColor {
    static func hexStringToUIColor (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        guard cString.hasPrefix("#") == true else {
            assertionFailure(kIncorrectColorFormat)
            return .gray
        }
        cString.remove(at: cString.startIndex)
        
        guard (cString.count) == 6 else {
            assertionFailure(kIncorrectColorFormat)
            return .gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    static var primary: UIColor {
        return hexStringToUIColor(hex: "#2A8671")
    }
    
    static var primaryAlpha20: UIColor {
        return hexStringToUIColor(hex: "#2A8671").withAlphaComponent(0.20)
    }
    
    static var lightGray: UIColor {
        return hexStringToUIColor(hex: "#EBF0FF")
    }
    
    static var overlay: UIColor {
        return hexStringToUIColor(hex: "#050505").withAlphaComponent(0.5)
    }
    
    static var blackAlpha15: UIColor {
        return UIColor.black.withAlphaComponent(0.15)
    }
}

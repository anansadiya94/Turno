//
//  CustomLabelThemes.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

protocol CustomLabelTheme {
    var label: String {get set}
    var font: UIFont {get}
    var textColor: UIColor {get}
    var textAlignment: NSTextAlignment {get}
    var numberOfLines: Int {get}
    var adjustsFontSizeToFitWidth: Bool {get}
}

struct BoldTheme: CustomLabelTheme {
    var textAlignment: NSTextAlignment
    var label: String
    var font: UIFont
    var textColor: UIColor = .white
    var numberOfLines: Int
    var adjustsFontSizeToFitWidth: Bool

    init(label: String, fontSize: CGFloat, textColor: UIColor, textAlignment: NSTextAlignment, numberOfLines: Int = 0, adjustsFontSizeToFitWidth: Bool = false) {
        self.label = label.localized
        self.font = UIFont(name: ServiceAppFont.boldFont, size: fontSize) ?? .boldSystemFont(ofSize: fontSize)
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
    }
}

struct SemiBoldTheme: CustomLabelTheme {
    var textAlignment: NSTextAlignment
    var label: String
    var font: UIFont
    var textColor: UIColor
    var numberOfLines: Int
    var adjustsFontSizeToFitWidth: Bool

    init(label: String, fontSize: CGFloat, textColor: UIColor, textAlignment: NSTextAlignment, numberOfLines: Int = 0, adjustsFontSizeToFitWidth: Bool = false) {
        self.label = label.localized
        self.font = UIFont(name: ServiceAppFont.semiBoldFont, size: fontSize) ?? .systemFont(ofSize: fontSize)
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
    }
}

struct RegularTheme: CustomLabelTheme {
    var textAlignment: NSTextAlignment
    var label: String
    var font: UIFont
    var textColor: UIColor
    var numberOfLines: Int
    var adjustsFontSizeToFitWidth: Bool

    init(label: String, fontSize: CGFloat, textColor: UIColor, textAlignment: NSTextAlignment, numberOfLines: Int = 0, adjustsFontSizeToFitWidth: Bool = false) {
        self.label = label.localized
        self.font = UIFont(name: ServiceAppFont.regularFont, size: fontSize) ?? .systemFont(ofSize: fontSize)
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
    }
}

struct Lightheme: CustomLabelTheme {
    var textAlignment: NSTextAlignment
    var label: String
    var font: UIFont
    var textColor: UIColor
    var numberOfLines: Int
    var adjustsFontSizeToFitWidth: Bool

    init(label: String, fontSize: CGFloat, textColor: UIColor, textAlignment: NSTextAlignment, numberOfLines: Int = 0, adjustsFontSizeToFitWidth: Bool = false) {
        self.label = label.localized
        self.font = UIFont(name: ServiceAppFont.lightFont, size: fontSize) ?? .systemFont(ofSize: fontSize)
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
    }
}

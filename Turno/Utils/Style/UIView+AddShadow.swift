//
//  UIView+AddShadow.swift
//  Turno
//
//  Created by Anan Sadiya on 28/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(shadowColor: CGColor, shadowRadius: CGFloat, shadowOffset: CGSize, shadowOpacity: Float) {
        self.layer.shadowColor = shadowColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
    }
}

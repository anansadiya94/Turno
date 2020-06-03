//
//  UICollectionViewExtension.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func getCurrentPage() -> Int {
        return Int(round(self.contentOffset.x / self.frame.size.width))
    }

    func getCurrentPage(byWidth: CGFloat) -> Int {
        return Int(round(self.contentOffset.x / byWidth))
    }
}

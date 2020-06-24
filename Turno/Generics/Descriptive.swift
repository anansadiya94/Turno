//
//  Descriptive.swift
//  Turno
//
//  Created by Anan Sadiya on 24/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable force_cast

protocol DescriptiveProtocol {
    var sectionDescriptor: [SectionDescriptor] { get }
}

struct CellDescriptor {
    var height: CGFloat = 0
    let cellClass: UITableViewCell.Type
    let reuseIdentifier: String
    let configure: (UITableViewCell) -> Void
    let didSelect: (UITableViewCell) -> Void

    init<T: UITableViewCell>(configure: @escaping (T) -> Void, didSelect: @escaping (T) -> Void) {
        self.cellClass = T.self
        self.reuseIdentifier = String(describing: T.self)
        self.configure = { cell in
            configure(cell as! T)
        }
        self.didSelect = { cell in
            didSelect(cell as! T)
        }
    }
}

struct SectionDescriptor {
    var descriptors = [CellDescriptor]()

    init(descriptorsList: [CellDescriptor]) {
        descriptors = descriptorsList
    }
}

//
//  AppointmentsListDescriptive.swift
//  Turno
//
//  Created by Anan Sadiya on 07/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable unused_closure_parameter

struct AppointmentsListDescriptive: DescriptiveProtocol {
    var sectionDescriptor: [SectionDescriptor]
    var descriptors: [CellDescriptor]
    var modelList = [ModelBusiness]()

    init(modelList: [ModelBusiness] ) {
        self.modelList = modelList
        var descriptorsTemp = [CellDescriptor]()
        for model in modelList {
            descriptorsTemp.append(CellDescriptor(configure: { (cell: AppointmentTableViewCell) in
                cell.config(model: model)
            }, didSelect: { (cell: AppointmentTableViewCell) in
                print("Selected")
            }))
        }
        descriptors = descriptorsTemp
        sectionDescriptor = [SectionDescriptor(descriptorsList: descriptors)]
    }
}

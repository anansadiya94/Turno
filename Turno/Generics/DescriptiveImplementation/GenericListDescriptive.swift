//
//  HomeCellsDescriptive.swift
//  Turno
//
//  Created by Anan Sadiya on 24/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

struct GenericListDescriptive: DescriptiveProtocol {
    var sectionDescriptor: [SectionDescriptor]
    var descriptors: [CellDescriptor]
    var modelList = [ModelBusiness]()
    
    init(modelList: [ModelBusiness] ) {
        self.modelList = modelList
        var descriptorsTemp = [CellDescriptor]()
        for model in modelList {
            descriptorsTemp.append(CellDescriptor(configure: { (cell: GenericEntityTableViewCell) in
                cell.config(model: model)
            }, didSelect: { _ in }))
        }
        descriptors = descriptorsTemp
        sectionDescriptor = [SectionDescriptor(descriptorsList: descriptors)]
    }
}

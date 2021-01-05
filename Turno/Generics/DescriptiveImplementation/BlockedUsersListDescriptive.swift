//
//  BlockedUsersListDescriptive.swift
//  Turno
//
//  Created by Anan Sadiya on 30/12/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

// swiftlint:disable unused_closure_parameter

struct BlockedUsersListDescriptive: DescriptiveProtocol {
    var sectionDescriptor: [SectionDescriptor]
    var descriptors: [CellDescriptor]
    var modelList = [ModelBlockedUser]()
    
    init(modelList: [ModelBlockedUser] ) {
        self.modelList = modelList
        var descriptorsTemp = [CellDescriptor]()
        for model in modelList {
            descriptorsTemp.append(CellDescriptor(configure: { (cell: BlockedUserTableViewCell) in
                cell.config(userId: model.userId, fullName: model.fullName, phoneNumber: model.phoneNumber)
            }, didSelect: { (cell: BlockedUserTableViewCell) in
                print("Selected")
            }))
        }
        descriptors = descriptorsTemp
        sectionDescriptor = [SectionDescriptor(descriptorsList: descriptors)]
    }
}

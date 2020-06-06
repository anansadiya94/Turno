//
//  ModelAlert.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct ModelAlertPopup {
    let title: String?
    let message: String?
    let action1: String?
    let action2: String?
    
    init(title: String? = nil, message: String? = nil, action1: String? = nil, action2: String? = nil) {
        self.title = title
        self.message = message
        self.action1 = action1
        self.action2 = action2
    }
}

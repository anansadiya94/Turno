//
//  PresenterBusinessMain.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class PresenterBusinessMain: NSObject {
    
    // MARK: - Properties
    var view: BusinessMainViewController!
    
    // MARK: - Public Interface
    init(view: BusinessMainViewController) {
        super.init()
        self.view = view
    }
}

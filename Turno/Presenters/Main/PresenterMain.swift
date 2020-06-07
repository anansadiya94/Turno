//
//  PresenterMain.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class PresenterMain: NSObject {
    
    // MARK: - Properties
    var view: MainViewController!
    
    // MARK: - Public Interface
    init(view: MainViewController) {
        super.init()
        self.view = view
    }
}

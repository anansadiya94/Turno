//
//  PresenterMain.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class PresenterUserMain: NSObject {
    
    // MARK: - Properties
    var view: UserMainViewController!
    
    // MARK: - Public Interface
    init(view: UserMainViewController) {
        super.init()
        self.view = view
    }
}

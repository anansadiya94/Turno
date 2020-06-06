//
//  PresenterActivation.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class PresenterActivation: NSObject {
    
    // MARK: - Properties
    var view: ActivationViewController!
    var delegate: SelectButtonWelcome!
    
    // MARK: - Public Interface
    init(view: ActivationViewController, delegate: SelectButtonWelcome) {
        super.init()
        self.view = view
        self.delegate = delegate
    }
}

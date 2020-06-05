//
//  PresenterInstallation.swift
//  Turno
//
//  Created by Anan Sadiya on 05/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class PresenterInstallation: NSObject {
    
    // MARK: - Properties
    var view: InstallationViewController!
    var delegate: SelectButtonWelcome!
    
    // MARK: - Public Interface
    init(view: InstallationViewController, delegate: SelectButtonWelcome) {
        super.init()
        self.view = view
        self.delegate = delegate
    }
    
    // MARK: - UI interaction methods
    func continueButtonTapped() {
        delegate.didSelectInstallationContinueButton()
    }
}

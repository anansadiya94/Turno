//
//  PresenterWelcome.swift
//  Turno
//
//  Created by Anan Sadiya on 04/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class PresenterWelcome: NSObject {
    
    // MARK: - Properties
    var view: WelcomeViewController!
    var delegate: SelectButtonWelcome!
    
    // MARK: - Public Interface
    init(view: WelcomeViewController, delegate: SelectButtonWelcome) {
        super.init()
        self.view = view
        self.delegate = delegate
    }
    
    // MARK: - UI interaction methods
    func continueButtonTapped() {
        delegate.didSelectWelcomeContinueButton()
    }

    //TODO: Where to?
    func privacyPolicyButtonTapped() {
        print("privacyPolicyButtonTapped")
    }
}
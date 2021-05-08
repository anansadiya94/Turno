//
//  PresenterWelcome.swift
//  Turno
//
//  Created by Anan Sadiya on 04/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class PresenterWelcome: NSObject {
    
    // MARK: - Properties
    var view: WelcomeViewController!
    private var delegate: SelectButtonWelcome?
    
    // MARK: - Public Interface
    init(view: WelcomeViewController, delegate: SelectButtonWelcome) {
        super.init()
        self.view = view
        self.delegate = delegate
    }
    
    // MARK: - UI interaction methods
    func continueButtonTapped() {
        delegate?.didSelectWelcomeContinueButton()
    }
    
    func privacyPolicyButtonTapped() {
//        if let privacyPolicyUrl = UIApplication.privacyPolicyUrl {
//            self.view.openUrl(privacyPolicyUrl)
//        }
        delegate?.didPrivacyPolicyTapped()
    }
}

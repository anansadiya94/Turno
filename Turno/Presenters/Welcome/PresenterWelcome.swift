//
//  PresenterWelcome.swift
//  Turno
//
//  Created by Anan Sadiya on 04/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class PresenterWelcome {
    
    // MARK: - Properties
    var view: WelcomeViewController!
    private let analyticsManager: AnalyticsManagerProtocol
    private weak var delegate: SelectButtonWelcome?
    
    private struct Constants {
        static let screenName = "Welcome Screen"
        static let continueAnalyticValue = LocalizedConstants.continue_key.enLocalized
        static let privacyPolicyAnalyticValue = LocalizedConstants.privacy_policy_key.enLocalized
    }
    
    // MARK: - Public Interface
    init(view: WelcomeViewController,
         analyticsManager: AnalyticsManagerProtocol,
         delegate: SelectButtonWelcome) {
        self.view = view
        self.analyticsManager = analyticsManager
        self.delegate = delegate
    }
    
    // MARK: - UI interaction methods
    func continueButtonTapped() {
        analyticsManager.track(eventKey: .buttonTapped, withProperties: [
            .buttonText: Constants.continueAnalyticValue,
            .screenName: Constants.screenName
        ])
        delegate?.didSelectWelcomeContinueButton()
    }
    
    func privacyPolicyButtonTapped() {
        analyticsManager.track(eventKey: .buttonTapped, withProperties: [
            .buttonText: Constants.privacyPolicyAnalyticValue,
            .screenName: Constants.screenName
        ])
        delegate?.didPrivacyPolicyTapped()
    }
}

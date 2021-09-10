//
//  PresenterSettings.swift
//  Turno
//
//  Created by Anan Sadiya on 22/11/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

protocol PresenterSettingsView: PresenterParentView {
    func share()
}

class PresenterSettings: NSObject {
    
    // MARK: - Properties
    private let analyticsManager: AnalyticsManagerProtocol
    private weak var view: PresenterSettingsView?
    private weak var userDelegate: SelectButtonEntity?
    private weak var businessDelegate: SelectButtonBusiness?
    
    private struct Constants {
        static let screenName = "Settings Screen"
    }
    
    // MARK: - init Methods
    init(view: PresenterSettingsView,
         analyticsManager: AnalyticsManagerProtocol,
         delegate: SelectButtonEntity) {
        self.view = view
        self.analyticsManager = analyticsManager
        self.userDelegate = delegate
    }
    
    init(view: PresenterSettingsView,
         analyticsManager: AnalyticsManagerProtocol,
         delegate: SelectButtonBusiness) {
        self.view = view
        self.analyticsManager = analyticsManager
        self.businessDelegate = delegate
    }
    
    // MARK: - Public Interface
    func trackScreen() {
        analyticsManager.track(eventKey: .settingsScreenSeen, withProperties: nil)
    }
    
    func trackSettingsRow(_ row: String) {
        analyticsManager.track(eventKey: .settingsTapped, withProperties: [
            .settingsRow: row,
            .screenName: Constants.screenName
        ])
    }
    
    // MARK: - UI interaction methods
    func changeToUser() {
        if let businessDelegate = businessDelegate {
            AppData.isBusiness = false
            businessDelegate.didSelectChangeToUser()
        }
    }
    
    func changeToBusiness() {
        if let userDelegate = userDelegate {
            AppData.isBusiness = true
            userDelegate.didSelectChangeToBusiness()
        }
    }
    
    func share() {
        self.view?.share()
    }
    
    func notifications() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
           UIApplication.shared.open(settingsUrl)
         }
    }
    
    func blockedUsers() {
        if let businessDelegate = businessDelegate {
            businessDelegate.didSelectBlockedUsers()
        }
    }
    
    func openWebView(for webViewType: WebViewType) {
        if let userDelegate = userDelegate {
            userDelegate.didSelectSettingsType(webViewType: webViewType)
        }
        if let businessDelegate = businessDelegate {
            businessDelegate.didSelectSettingsType(webViewType: webViewType)
        }
    }
}

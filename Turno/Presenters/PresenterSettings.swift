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
    private weak var view: PresenterSettingsView?
    private weak var userDelegate: SelectButtonEntity?
    private weak var businessDelegate: SelectButtonBusiness?
    
    // MARK: - init Methods
    init(view: PresenterSettingsView, delegate: SelectButtonEntity) {
        self.view = view
        self.userDelegate = delegate
    }
    
    init(view: PresenterSettingsView, delegate: SelectButtonBusiness) {
        self.view = view
        self.businessDelegate = delegate
    }
    
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

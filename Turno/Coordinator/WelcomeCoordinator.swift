//
//  WelcomeCoordinator.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

class WelcomeCoordinator: Coordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow = UIWindow(), navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
    }
}

extension WelcomeCoordinator {
    
    func showInstallationScreen(delegate: SelectButtonWelcome) {
        let screen = ScreenFactory.makeInstallationScreen(delegate: delegate)
        navigationController.pushViewController(screen, animated: true)
    }
    
    func showActivationScreen(delegate: SelectButtonWelcome) {
        let screen = ScreenFactory.makeActivationScreen(delegate: delegate)
        navigationController.pushViewController(screen, animated: true)
    }
    
    func showMainScreen() {
        navigationController.isNavigationBarHidden = true
        let screen = ScreenFactory.makeMainScreen(navigationController: navigationController)
        window.rootViewController = screen
    }
}

extension WelcomeCoordinator: SelectButtonWelcome {
    func didSelectWelcomeContinueButton() {
        showInstallationScreen(delegate: self)
    }
    
    func didSelectAlertYesButton() {
        showActivationScreen(delegate: self)
    }
    
    func didOPTTapped() {
        showMainScreen()
    }
}

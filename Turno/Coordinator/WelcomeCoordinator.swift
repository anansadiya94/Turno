//
//  WelcomeCoordinator.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

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
    
    func showActivationScreen(delegate: SelectButtonWelcome, modelSignUp: ModelSignUp) {
        let screen = ScreenFactory.makeActivationScreen(delegate: delegate, modelSignUp: modelSignUp)
        navigationController.pushViewController(screen, animated: true)
    }
    
    func showMainScreen() {
        let mainCoordinator = UserMainCoordinator(window: window, navigationController: navigationController)
        let screen = ScreenFactory.makeUserMainScreen(navigationController: navigationController, delegate: mainCoordinator)
        window.rootViewController = screen
    }
    
    func showBusinessMainScreen() {
        let mainCoordinator = BusinessMainCoordinator(window: window, navigationController: navigationController)
        let screen = ScreenFactory.makeBusinessMainScreen(navigationController: navigationController, delegate: mainCoordinator)
        window.rootViewController = screen
    }
}

extension WelcomeCoordinator: SelectButtonWelcome {
    func didSelectWelcomeContinueButton() {
        showInstallationScreen(delegate: self)
    }
    
    func didSelectAlertYesButton(modelSignUp: ModelSignUp) {
        showActivationScreen(delegate: self, modelSignUp: modelSignUp)
    }
    
    func didOPTTapped(isBusiness: Bool) {
        if isBusiness {
            showBusinessMainScreen()
        } else {
            showMainScreen()
        }
    }
}

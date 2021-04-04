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
    private let networkManager: NetworkManagerProtocol
    
    init(window: UIWindow = UIWindow(), navigationController: UINavigationController = UINavigationController(), networkManager: NetworkManagerProtocol) {
        self.window = window
        self.navigationController = navigationController
        self.networkManager = networkManager
    }
    
    func start() {
    }
}

extension WelcomeCoordinator {
    
    func showInstallationScreen(delegate: SelectButtonWelcome) {
        let screen = ScreenFactory.makeInstallationScreen(networkManager: networkManager, delegate: delegate)
        navigationController.pushViewController(screen, animated: true)
    }
    
    func showActivationScreen(delegate: SelectButtonWelcome, modelSignUp: ModelSignUp) {
        let screen = ScreenFactory.makeActivationScreen(networkManager: networkManager, delegate: delegate, modelSignUp: modelSignUp)
        navigationController.pushViewController(screen, animated: true)
    }
    
    func showMainScreen() {
        let mainCoordinator = UserMainCoordinator(window: window, navigationController: navigationController, networkManager: networkManager)
        let screen = ScreenFactory.makeUserMainScreen(networkManager: networkManager,
                                                      navigationController: navigationController,
                                                      delegate: mainCoordinator)
        window.rootViewController = screen
    }
    
    func showBusinessMainScreen() {
        let mainCoordinator = BusinessMainCoordinator(window: window, navigationController: navigationController, networkManager: networkManager)
        let screen = ScreenFactory.makeBusinessMainScreen(navigationController: navigationController,
                                                          networkManager: networkManager,
                                                          delegate: mainCoordinator)
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

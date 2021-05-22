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
    private var userMainCoordinator: UserMainCoordinator
    private var businessMainCoordinator: BusinessMainCoordinator
    
    init(window: UIWindow = UIWindow(),
         navigationController: UINavigationController = UINavigationController(),
         networkManager: NetworkManagerProtocol) {
        self.window = window
        self.navigationController = navigationController
        self.networkManager = networkManager
        
        // Coordinators configurations
        userMainCoordinator = UserMainCoordinator(window: window,
                                                  navigationController: navigationController,
                                                  networkManager: networkManager)
        businessMainCoordinator = BusinessMainCoordinator(window: window,
                                                          navigationController: navigationController,
                                                          networkManager: networkManager)
    }
    
    func start() {}
}

extension WelcomeCoordinator {
    
    func showInstallationScreen(delegate: SelectButtonWelcome) {
        let screen = ScreenFactory.makeInstallationScreen(networkManager: networkManager,
                                                          delegate: delegate)
        navigationController.pushViewController(screen, animated: true)
    }
    
    func showActivationScreen(delegate: SelectButtonWelcome, modelSignUp: ModelSignUp) {
        let screen = ScreenFactory.makeActivationScreen(networkManager: networkManager,
                                                        delegate: delegate,
                                                        modelSignUp: modelSignUp)
        navigationController.pushViewController(screen, animated: true)
    }
    
    func showMainScreen() {
        let screen = ScreenFactory.makeUserMainScreen(networkManager: networkManager,
                                                      navigationController: navigationController,
                                                      delegate: userMainCoordinator)
        window.rootViewController = screen
    }
    
    func showBusinessMainScreen() {
        let screen = ScreenFactory.makeBusinessMainScreen(navigationController: navigationController,
                                                          networkManager: networkManager,
                                                          delegate: businessMainCoordinator)
        window.rootViewController = screen
    }
    
    func showPrivacyPolicy() {
        let screen = ScreenFactory.makeWebViewScreen(webViewType: .termsOfUse)
        
        // Push view controller with a present animation.
        screen.navigationItem.leftBarButtonItem = UIBarButtonItem(title: LocalizedConstants.close_key.localized,
                                                                  style: .plain, target: screen,
                                                                  action: #selector(WebViewController.closeView))
        screen.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: screen, action: nil)
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        navigationController.view.layer.add(transition, forKey: nil)
        navigationController.pushViewController(screen, animated: false)
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
    
    func didPrivacyPolicyTapped() {
        showPrivacyPolicy()
    }
}

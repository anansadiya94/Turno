//
//  OnBoardingCoordinator.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class OnBoardingCoordinator: Coordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let networkManager: NetworkManagerProtocol
    private var welcomeCoordinator: WelcomeCoordinator
    private var userMainCoordinator: UserMainCoordinator
    private var businessMainCoordinator: BusinessMainCoordinator
    
    init(window: UIWindow = UIWindow(),
         navigationController: UINavigationController = UINavigationController(),
         networkManager: NetworkManagerProtocol) {
        self.window = window
        self.navigationController = navigationController
        self.networkManager = networkManager
        
        // Coordinators configurations
        welcomeCoordinator = WelcomeCoordinator(window: window,
                                                navigationController: navigationController,
                                                networkManager: networkManager)
        userMainCoordinator = UserMainCoordinator(window: window,
                                                  navigationController: navigationController,
                                                  networkManager: networkManager)
        businessMainCoordinator = BusinessMainCoordinator(window: window,
                                                          navigationController: navigationController,
                                                          networkManager: networkManager)
    }
    
    func start() {
        if AppData.onBoardingCompleted {
            guard let appState = Preferences.getPrefsAppState() else { return }
            switch appState {
            case .unregistered:
                showWelcomeScreen()
            case .loggedIn:
                if Preferences.isBusiness() && AppData.isBusiness {
                    showBusinessMainScreen()
                } else {
                    showMainScreen()
                }
            case .sessionExpired:
                showWelcomeScreen()
            }
        } else {
            showOnboardingScreen()
        }
    }
}

extension OnBoardingCoordinator {
    
    func showOnboardingScreen() {
        Preferences.setPrefsAppState(value: .unregistered)
        let screen = ScreenFactory.makeOnboardingScreen(delegate: self)
        window.rootViewController = screen
    }
    
    func showWelcomeScreen() {
        let screen = ScreenFactory.makeWelcomeScreen(navigationController: navigationController,
                                                     delegate: welcomeCoordinator)
        window.rootViewController = screen
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
}

extension OnBoardingCoordinator: SelectButtonOnboarding {
    func didSelectOnboardingButton() {
        showWelcomeScreen()
    }
}

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
    private let analyticsManager: AnalyticsManagerProtocol
    private let forceUpdateManager: ForceUpdateManagerProtocol
    private let welcomeCoordinator: WelcomeCoordinator
    private let userMainCoordinator: UserMainCoordinator
    private let businessMainCoordinator: BusinessMainCoordinator
    
    init(window: UIWindow = UIWindow(),
         navigationController: UINavigationController = UINavigationController(),
         networkManager: NetworkManagerProtocol,
         analyticsManager: AnalyticsManagerProtocol,
         forceUpdateManager: ForceUpdateManagerProtocol) {
        self.window = window
        self.navigationController = navigationController
        self.networkManager = networkManager
        self.analyticsManager = analyticsManager
        self.forceUpdateManager = forceUpdateManager
        
        // Coordinators configurations
        welcomeCoordinator = WelcomeCoordinator(window: window,
                                                navigationController: navigationController,
                                                networkManager: networkManager,
                                                analyticsManager: analyticsManager,
                                                forceUpdateManager: forceUpdateManager)
        userMainCoordinator = UserMainCoordinator(window: window,
                                                  navigationController: navigationController,
                                                  networkManager: networkManager,
                                                  analyticsManager: analyticsManager,
                                                  forceUpdateManager: forceUpdateManager)
        businessMainCoordinator = BusinessMainCoordinator(window: window,
                                                          navigationController: navigationController,
                                                          networkManager: networkManager,
                                                          analyticsManager: analyticsManager,
                                                          forceUpdateManager: forceUpdateManager)
        
        addObservers()
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
        let screen = ScreenFactory.makeOnboardingScreen(analyticsManager: analyticsManager,
                                                        delegate: self)
        window.rootViewController = screen
    }
    
    @objc func showWelcomeScreen() {
        let screen = ScreenFactory.makeWelcomeScreen(navigationController: navigationController,
                                                     analyticsManager: analyticsManager,
                                                     delegate: welcomeCoordinator)
        window.rootViewController = screen
    }
    
    @objc func showMainScreen() {
        let screen = ScreenFactory.makeUserMainScreen(navigationController: navigationController,
                                                      networkManager: networkManager,
                                                      analyticsManager: analyticsManager,
                                                      forceUpdateManager: forceUpdateManager,
                                                      delegate: userMainCoordinator)
        window.rootViewController = screen
    }
    
    @objc func showBusinessMainScreen() {
        let screen = ScreenFactory.makeBusinessMainScreen(navigationController: navigationController,
                                                          networkManager: networkManager,
                                                          analyticsManager: analyticsManager,
                                                          forceUpdateManager: forceUpdateManager,
                                                          delegate: businessMainCoordinator)
        window.rootViewController = screen
    }
}

extension OnBoardingCoordinator: SelectButtonOnboarding {
    func didSelectOnboardingButton() {
        showWelcomeScreen()
    }
}

private extension OnBoardingCoordinator {
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showMainScreen),
                                               name: Settings.changeToUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showBusinessMainScreen),
                                               name: Settings.changeToBusiness, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showWelcomeScreen),
                                               name: Settings.signOutUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showWelcomeScreen),
                                               name: Settings.signOutBusiness, object: nil)
    }
}

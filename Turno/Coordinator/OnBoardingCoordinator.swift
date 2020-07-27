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
    
    init(window: UIWindow = UIWindow(), navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        if AppData.onBoardingCompleted {
            guard let appState = Preferences.getPrefsAppState() else { return }
            switch appState {
            case .unregistered:
                showWelcomeScreen()
            case .loggedIn:
                showMainScreen()
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
        let welcomeCoordinator = WelcomeCoordinator(window: window, navigationController: navigationController)
        let screen = ScreenFactory.makeWelcomeScreen(navigationController: navigationController, delegate: welcomeCoordinator)
        window.rootViewController = screen
    }
    
    func showMainScreen() {
        let mainCoordinator = MainCoordinator(window: window, navigationController: navigationController)
        let screen = ScreenFactory.makeMainScreen(navigationController: navigationController, delegate: mainCoordinator)
        window.rootViewController = screen
    }
}

extension OnBoardingCoordinator: SelectButtonOnboarding {
    func didSelectOnboardingButton() {
        showWelcomeScreen()
    }
}

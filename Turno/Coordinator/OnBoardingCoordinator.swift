//
//  OnBoardingCoordinator.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
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
            switch App.state {
            case .unregistered:
                showWelcomeScene()
            case .loggedIn:
                showMainScreen()
            case .sessionExpired:
                showWelcomeScene()
            }
        } else {
            showOnboardingScene()
        }
    }
}

extension OnBoardingCoordinator {
    
    func showOnboardingScene() {
        let screen = ScreenFactory.makeOnboardingScreen(delegate: self)
        window.rootViewController = screen
    }
    
    func showWelcomeScene() {
        let welcomeCoordinator = WelcomeCoordinator(window: window, navigationController: navigationController)
        let screen = ScreenFactory.makeWelcomeScreen(navigationController: navigationController, delegate: welcomeCoordinator)
        window.rootViewController = screen
    }
    
    func showMainScreen() {
        
    }
}

extension OnBoardingCoordinator: SelectButtonOnboarding {
    func didSelectOnboardingButton() {
        showWelcomeScene()
    }
}

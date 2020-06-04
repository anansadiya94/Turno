//
//  ScreenFactory.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import  UIKit

//PROTOCOLS:
protocol SelectButtonOnboarding: class {
    func didSelectOnboardingButton()
}
protocol SelectButtonWelcome: class {
    
}

struct ScreenFactory {
    //ONBOARDING:
    static func makeOnboardingScreen(delegate: SelectButtonOnboarding) -> UIViewController {
        let onBoardingViewController = OnboardingViewController()
        let presenter = PresenterOnboarding(view: onBoardingViewController, delegate: delegate)
        onBoardingViewController.presenterOnboarding = presenter
        return onBoardingViewController
    }
    
    //WELCOME:
    static func makeWelcomeScreen(navigationController: UINavigationController, delegate: SelectButtonWelcome) -> UIViewController {
        let welcomeViewController = UIViewController()
        welcomeViewController.view.backgroundColor = .red
//        let presenter = PresenterWelcome(view: welcomeViewController, delegate: delegate)
//        welcomeViewController.presenterWelcome = presenter
        navigationController.viewControllers = [welcomeViewController]
        return navigationController
    }
}

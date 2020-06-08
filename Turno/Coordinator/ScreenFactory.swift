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
    func didSelectWelcomeContinueButton()
    func showAlert(view: UIViewController, modelAlertPopup: ModelAlertPopup)
    func didSelectAlertYesButton()
    func didSelectFinishButton()
}

protocol SelectButtonHome: class {
    func didSelectButton()
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
        let welcomeViewController = WelcomeViewController()
        let presenter = PresenterWelcome(view: welcomeViewController, delegate: delegate)
        welcomeViewController.presenterWelcome = presenter
        navigationController.viewControllers = [welcomeViewController]
        return navigationController
    }
    
    static func makeInstallationScreen(delegate: SelectButtonWelcome) -> UIViewController {
        let viewController = InstallationViewController()
        let presenter = PresenterInstallation(view: viewController, delegate: delegate)
        viewController.presenterInstallation = presenter
        return viewController
    }
    
    static func makeActivationScreen(delegate: SelectButtonWelcome) -> UIViewController {
        let viewController = ActivationViewController()
        let presenter = PresenterActivation(view: viewController, delegate: delegate)
        viewController.presenterActivation = presenter
        return viewController
    }
    
    //ALERT:
    static func makeAlertPopupScreen(delegate: SelectButtonWelcome, modelAlertPopup: ModelAlertPopup) -> UIViewController {
        let viewController = AlertPopupViewController()
        let presnter = PresenterAlertPopup(view: viewController, delegate: delegate, modelAlertPopup: modelAlertPopup)
        viewController.presenterAlertPopup = presnter
        return viewController
    }
    
    //MAIN:
    static func makeMainScreen(navigationController: UINavigationController) -> UIViewController {
        let mainViewController = ServiceViewController.instantiateViewControllerWithStoryBoard(sbName: kMainStoryboardName,
                                                                                               vcID: kMainViewControllerID) as? MainViewController
        
        if let mainVC = mainViewController {
//            if let viewController = mainVC.viewControllers?[0] as? UINavigationController {
//                if let homeVC = viewController.topViewController as? HomeViewController {
//                    let presnter = PresenterExplore(view: exploreVC, delegate: delegate)
//                    exploreVC.presenterExplore = presnter
//                }
//            }
            let presenter = PresenterMain(view: mainVC)
            mainVC.presenterMain = presenter
            navigationController.viewControllers = [mainVC]
        }
        return navigationController
    }
}

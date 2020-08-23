//
//  ScreenFactory.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

//PROTOCOLS:
protocol SelectButtonOnboarding: class {
    func didSelectOnboardingButton()
}

protocol SelectButtonWelcome: class {
    func didSelectWelcomeContinueButton()
    func didSelectAlertYesButton(modelSignUp: ModelSignUp)
    func didOPTTapped()
}

protocol SelectButtonEntity: class {
    func didSelectEntity(model: ModelBusiness)
    func didSelectCheckAvailability(identifier: String?, name: String?, bookedServices: [Service]?)
}

protocol SelectButtonFavorites: class {
    func didSelectEntity(id: String)
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
    
    static func makeActivationScreen(delegate: SelectButtonWelcome, modelSignUp: ModelSignUp) -> UIViewController {
        let viewController = ActivationViewController()
        let presenter = PresenterActivation(view: viewController, delegate: delegate, modelSignUp: modelSignUp)
        viewController.presenterActivation = presenter
        return viewController
    }
    
    //MAIN:
    static func makeMainScreen(navigationController: UINavigationController, delegate: SelectButtonEntity) -> UIViewController {
        let mainViewController = ServiceViewController.instantiateViewControllerWithStoryBoard(sbName: kMainStoryboardName,
                                                                                               vcID: kMainViewControllerID) as? MainViewController
        
        if let mainVC = mainViewController {
            if let viewController = mainVC.viewControllers?[0] as? UINavigationController {
                if let homeVC = viewController.topViewController as? HomeViewController {
                    let presnter = PresenterHome(view: homeVC, delegate: delegate)
                    homeVC.presenterHome = presnter
                }
            }
            if let viewController = mainVC.viewControllers?[1] as? UINavigationController {
                if let appointmentsVC = viewController.topViewController as? AppointmentsViewController {
                    let presnter = PresenterAppointments(view: appointmentsVC, delegate: delegate)
                    appointmentsVC.presenterAppointments = presnter
                }
            }
            if let viewController = mainVC.viewControllers?[2] as? UINavigationController {
                if let favoritesVC = viewController.topViewController as? FavoritesViewController {
                    let presnter = PresenterFavorites(view: favoritesVC, delegate: delegate)
                    favoritesVC.presenterFavorites = presnter
                }
            }
            let presenter = PresenterMain(view: mainVC)
            mainVC.presenterMain = presenter
            navigationController.viewControllers = [mainVC]
        }
        return navigationController
    }
    
    static func makeBusinessScreen(delegate: SelectButtonEntity, model: ModelBusiness) -> UIViewController {
        let viewController = BusinessViewController()
        let presenter = PresenterBusiness(view: viewController, delegate: delegate, model: model)
        viewController.presenterBusiness = presenter
        return viewController
    }
    
    static func makeshowCheckAvailabilityScreen(delegate: SelectButtonEntity, identifier: String?, name: String?, bookedServices: [Service]?) -> UIViewController {
        let viewController = CheckAvailabilityViewController()
        let presenter = PresenterCheckAvailability(view: viewController, delegate: delegate, identifier: identifier,
                                                   name: name, bookedServices: bookedServices)
        viewController.presenterCheckAvailability = presenter
        return viewController
    }
}

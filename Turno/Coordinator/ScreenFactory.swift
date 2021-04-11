//
//  ScreenFactory.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

// PROTOCOLS:
protocol SelectButtonOnboarding: class {
    func didSelectOnboardingButton()
}

protocol SelectButtonWelcome: class {
    func didSelectWelcomeContinueButton()
    func didSelectAlertYesButton(modelSignUp: ModelSignUp)
    func didOPTTapped(isBusiness: Bool)
}

protocol SelectButtonEntity: SelectGenericSettings {
    func didSelectEntity(model: ModelBusiness)
    func didSelectCheckAvailability(identifier: String?, name: String?,
                                    bookedServices: [Service]?,
                                    modelCheckTurnsAvailability: ModelCheckTurnsAvailability?)
    func didSelectConfirm(identifier: String?, name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?)
    func didSelectChangeToBusiness()
}

protocol SelectButtonFavorites: class {
    func didSelectEntity(id: String)
}

protocol SelectGenericSettings: class {
    func didSelectSettingsType(webViewType: WebViewType)
}

struct ConfirmationScreenModel {
    let identifier: String?
    let name: String?
    let bookedServices: [Service]?
    let bookedSlot: EmptySlot?
    let confirmationViewType: ConfirmationViewType?
    let customer: Customer?
}

protocol SelectButtonBusiness: SelectGenericSettings {
    func addAppointmentTapped(modelBusiness: ModelBusiness?)
    func showAppointmentTapped(turn: Turn)
    func didSelectCheckAvailability(identifier: String?, name: String?,
                                    bookedServices: [Service]?,
                                    modelCheckTurnsAvailability: ModelCheckTurnsAvailability?,
                                    customer: Customer?)
    func didSelectConfirm(identifier: String?, name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?, customer: Customer?)
    func didSelectChangeToUser()
    func didSelectBlockedUsers()
}

struct ScreenFactory {
    // ONBOARDING:
    static func makeOnboardingScreen(delegate: SelectButtonOnboarding) -> UIViewController {
        let onBoardingViewController = OnboardingViewController()
        let presenter = PresenterOnboarding(view: onBoardingViewController, delegate: delegate)
        onBoardingViewController.presenterOnboarding = presenter
        return onBoardingViewController
    }
    
    // WELCOME:
    static func makeWelcomeScreen(navigationController: UINavigationController, delegate: SelectButtonWelcome) -> UIViewController {
        let welcomeViewController = WelcomeViewController()
        let presenter = PresenterWelcome(view: welcomeViewController, delegate: delegate)
        welcomeViewController.presenterWelcome = presenter
        navigationController.viewControllers = [welcomeViewController]
        return navigationController
    }
    
    static func makeInstallationScreen(networkManager: NetworkManagerProtocol, delegate: SelectButtonWelcome) -> UIViewController {
        let viewController = InstallationViewController()
        let presenter = PresenterInstallation(view: viewController, networkManager: networkManager, delegate: delegate)
        viewController.presenterInstallation = presenter
        return viewController
    }
    
    static func makeActivationScreen(networkManager: NetworkManagerProtocol, delegate: SelectButtonWelcome, modelSignUp: ModelSignUp) -> UIViewController {
        let viewController = ActivationViewController()
        let presenter = PresenterActivation(view: viewController, networkManager: networkManager, delegate: delegate, modelSignUp: modelSignUp)
        viewController.presenterActivation = presenter
        return viewController
    }
    
    // MAIN:
    static func makeUserMainScreen(networkManager: NetworkManagerProtocol, navigationController: UINavigationController, delegate: SelectButtonEntity) -> UIViewController {
        let mainViewController = ServiceViewController.instantiateViewControllerWithStoryBoard(
            sbName: kUserMainStoryboardName,
            vcID: kUserMainViewControllerID) as? UserMainViewController
        
        if let mainVC = mainViewController {
            if let viewController = mainVC.viewControllers?[0] as? UINavigationController {
                if let homeVC = viewController.topViewController as? UserHomeViewController {
                    let presenter = PresenterUserHome(view: homeVC, networkManager: networkManager, delegate: delegate)
                    homeVC.presenterHome = presenter
                }
            }
            if let viewController = mainVC.viewControllers?[1] as? UINavigationController {
                if let appointmentsVC = viewController.topViewController as? AppointmentsViewController {
                    let presenter = PresenterAppointments(view: appointmentsVC, networkManager: networkManager, delegate: delegate)
                    appointmentsVC.presenterAppointments = presenter
                }
            }
            if let viewController = mainVC.viewControllers?[2] as? UINavigationController {
                if let favoritesVC = viewController.topViewController as? FavoritesViewController {
                    let presenter = PresenterFavorites(view: favoritesVC, networkManager: networkManager, delegate: delegate)
                    favoritesVC.presenterFavorites = presenter
                }
            }
            if let viewController = mainVC.viewControllers?[3] as? UINavigationController {
                if let settingsVC = viewController.topViewController as? SettingsViewController {
                    let presenter = PresenterSettings(view: settingsVC, delegate: delegate)
                    settingsVC.presenterSettings = presenter
                }
            }
            let presenter = PresenterUserMain(view: mainVC)
            mainVC.presenterMain = presenter
            navigationController.viewControllers = [mainVC]
        }
        return navigationController
    }
    
    static func makeBusinessMainScreen(navigationController: UINavigationController, networkManager: NetworkManagerProtocol, delegate: SelectButtonBusiness) -> UIViewController {
        let mainViewController = ServiceViewController.instantiateViewControllerWithStoryBoard(
            sbName: kBusinessMainStoryboardName,
            vcID: kBusinessMainViewControllerID) as? BusinessMainViewController
        
        if let mainVC = mainViewController {
            if let viewController = mainVC.viewControllers?[0] as? UINavigationController {
                if let homeVC = viewController.topViewController as? BusinessHomeViewController {
                    let presenter = PresenterBusinessHome(view: homeVC, networkManager: networkManager, delegate: delegate)
                    homeVC.presenterHome = presenter
                }
            }
            if let viewController = mainVC.viewControllers?[1] as? UINavigationController {
                if let settingsVC = viewController.topViewController as? SettingsViewController {
                    let presenter = PresenterSettings(view: settingsVC, delegate: delegate)
                    settingsVC.presenterSettings = presenter
                }
            }
            let presenter = PresenterBusinessMain(view: mainVC)
            mainVC.presenterMain = presenter
            navigationController.viewControllers = [mainVC]
        }
        return navigationController
    }
    
    static func makeBusinessScreen(networkManager: NetworkManagerProtocol, delegate: SelectButtonEntity, model: ModelBusiness) -> UIViewController {
        let viewController = BusinessViewController()
        let presenter = PresenterBusiness(view: viewController, networkManager: networkManager, delegate: delegate, model: model)
        viewController.presenterBusiness = presenter
        return viewController
    }
    
    static func makeCheckAvailabilityScreen(networkManager: NetworkManagerProtocol,
                                            delegate: SelectButtonEntity,
                                            identifier: String?,
                                            name: String?,
                                            bookedServices: [Service]?,
                                            modelCheckTurnsAvailability: ModelCheckTurnsAvailability?) -> UIViewController {
        let viewController = CheckAvailabilityViewController()
        let presenter = PresenterCheckAvailability(view: viewController,
                                                   networkManager: networkManager,
                                                   delegate: delegate,
                                                   identifier: identifier,
                                                   name: name,
                                                   bookedServices: bookedServices,
                                                   modelCheckTurnsAvailability: modelCheckTurnsAvailability)
        viewController.presenterCheckAvailability = presenter
        return viewController
    }
    
    static func makeCheckAvailabilityScreen(networkManager: NetworkManagerProtocol,
                                            delegate: SelectButtonBusiness,
                                            identifier: String?,
                                            name: String?,
                                            bookedServices: [Service]?,
                                            modelCheckTurnsAvailability: ModelCheckTurnsAvailability?,
                                            customer: Customer?) -> UIViewController {
        let viewController = CheckAvailabilityViewController()
        let presenter = PresenterCheckAvailability(view: viewController,
                                                   networkManager: networkManager,
                                                   delegate: delegate,
                                                   identifier: identifier,
                                                   name: name,
                                                   bookedServices: bookedServices,
                                                   modelCheckTurnsAvailability: modelCheckTurnsAvailability,
                                                   customer: customer)
        viewController.presenterCheckAvailability = presenter
        return viewController
    }
    
    static func makeConfirmationScreen(networkManager: NetworkManagerProtocol,
                                       delegate: SelectButtonEntity,
                                       identifier: String?,
                                       name: String?,
                                       bookedServices: [Service]?,
                                       bookedSlot: EmptySlot?,
                                       confirmationViewType: ConfirmationViewType?) -> UIViewController {
        let viewController = ConfirmationViewController()
        let presenter = PresenterConfirmation(view: viewController,
                                              networkManager: networkManager,
                                              delegate: delegate,
                                              identifier: identifier,
                                              name: name,
                                              bookedServices: bookedServices,
                                              bookedSlot: bookedSlot,
                                              confirmationViewType: confirmationViewType)
        viewController.presenterConfirmation = presenter
        return viewController
    }
    
    static func makeConfirmationScreen(networkManager: NetworkManagerProtocol, delegate: SelectButtonBusiness, confirmationScreenModel: ConfirmationScreenModel) -> UIViewController {
        let viewController = ConfirmationViewController()
        let presenter = PresenterConfirmation(view: viewController,
                                              networkManager: networkManager,
                                              delegate: delegate,
                                              identifier: confirmationScreenModel.identifier,
                                              name: confirmationScreenModel.name,
                                              bookedServices: confirmationScreenModel.bookedServices,
                                              bookedSlot: confirmationScreenModel.bookedSlot,
                                              confirmationViewType: confirmationScreenModel.confirmationViewType,
                                              customer: confirmationScreenModel.customer)
        viewController.presenterConfirmation = presenter
        return viewController
    }
    
    static func makeAddAppointmentScreen(networkManager: NetworkManagerProtocol, modelBusiness: ModelBusiness?, delegate: SelectButtonBusiness) -> UIViewController {
        let viewController = AddAppointmentViewController()
        let presenter = PresenterAddAppointment(view: viewController,
                                                networkManager: networkManager,
                                                modelBusiness: modelBusiness,
                                                delegate: delegate)
        viewController.presenterAddAppointment = presenter
        return viewController
    }
    
    static func makeBlockedUsersScreen(networkManager: NetworkManagerProtocol, delegate: SelectButtonBusiness) -> UIViewController {
        let viewController = BlockedUsersViewController()
        let presenter = PresenterBlockedUsers(view: viewController, networkManager: networkManager, delegate: delegate)
        viewController.presenterBlockedUsers = presenter
        return viewController
    }
    
    static func makeWebViewScreen(webViewType: WebViewType) -> UIViewController {
        let viewController = WebViewController()
        viewController.webViewType = webViewType
        return viewController
    }
}

//
//  BusinessMainCoordinator.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class BusinessMainCoordinator: Coordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow = UIWindow(), navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
    }
}

extension BusinessMainCoordinator {
    func pushViewByHomeInnerViewController(screen: UIViewController) {
        if let mainVC = navigationController.viewControllers[0] as? BusinessMainViewController {
            if let homeVC = mainVC.viewControllers?[0] as? UINavigationController {
                homeVC.pushViewController(screen, animated: true)
            }
        }
    }
    
    func pushViewBySettingsInnerViewController(screen: UIViewController) {
        if let mainVC = navigationController.viewControllers[0] as? BusinessMainViewController {
            if let settingsVC = mainVC.viewControllers?[1] as? UINavigationController {
                settingsVC.pushViewController(screen, animated: true)
            }
        }
    }
    
    func showAddAppointmentScreen(modelBusiness: ModelBusiness?, delegate: SelectButtonBusiness) {
        let screen = ScreenFactory.makeAddAppointmentScreen(modelBusiness: modelBusiness, delegate: delegate)
        pushViewByHomeInnerViewController(screen: screen)
    }
    
    func showAppointmentScreen(turn: Turn) {
        let screen = ScreenFactory.makeConfirmationScreen(delegate: self,
                                                          identifier: turn.identifier,
                                                          name: "TODO",
                                                          bookedServices: turn.services,
                                                          bookedSlot: EmptySlot(slot: turn.dateTimeUTC, selected: true),
                                                          confirmationViewType: .business,
                                                          customer: Customer(name: turn.userName, phoneNumber: turn.userPhone))
        pushViewByHomeInnerViewController(screen: screen)
    }
    
    func showCheckAvailabilityScreen(identifier: String?, name: String?, bookedServices: [Service]?,
                                     modelCheckTurnsAvailability: ModelCheckTurnsAvailability?,
                                     customer: Customer?) {
        let screen = ScreenFactory.makeCheckAvailabilityScreen(delegate: self, identifier: identifier, name: name,
                                                               bookedServices: bookedServices,
                                                               modelCheckTurnsAvailability: modelCheckTurnsAvailability, customer: customer)
        pushViewByHomeInnerViewController(screen: screen)
    }
    
    func showConfirmationScreen(identifier: String?, name: String?, bookedServices: [Service]?,
                                bookedSlot: EmptySlot?, customer: Customer?) {
        let screen = ScreenFactory.makeConfirmationScreen(delegate: self,
                                                          identifier: identifier,
                                                          name: name,
                                                          bookedServices: bookedServices,
                                                          bookedSlot: bookedSlot,
                                                          confirmationViewType: .user, customer: customer)
        pushViewByHomeInnerViewController(screen: screen)
    }
    
    func showUserMainScreen() {
        let mainCoordinator = UserMainCoordinator(window: window, navigationController: navigationController)
        let screen = ScreenFactory.makeUserMainScreen(navigationController: navigationController, delegate: mainCoordinator)
        window.rootViewController = screen
    }
    
    func showBlockedUsersScreen() {
        let screen = ScreenFactory.makeBlockedUsersScreen(delegate: self)
        pushViewBySettingsInnerViewController(screen: screen)
    }
}

extension BusinessMainCoordinator: SelectButtonBusiness {
    func addAppointmentTapped(modelBusiness: ModelBusiness?) {
        showAddAppointmentScreen(modelBusiness: modelBusiness, delegate: self)
    }
    
    func showAppointmentTapped(turn: Turn) {
        showAppointmentScreen(turn: turn)
    }
    
    func didSelectCheckAvailability(identifier: String?, name: String?,
                                    bookedServices: [Service]?,
                                    modelCheckTurnsAvailability: ModelCheckTurnsAvailability?,
                                    customer: Customer?) {
        showCheckAvailabilityScreen(identifier: identifier, name: name, bookedServices: bookedServices,
                                    modelCheckTurnsAvailability: modelCheckTurnsAvailability, customer: customer)
    }
    
    func didSelectConfirm(identifier: String?, name: String?, bookedServices: [Service]?,
                          bookedSlot: EmptySlot?, customer: Customer?) {
        showConfirmationScreen(identifier: identifier, name: name, bookedServices: bookedServices, bookedSlot: bookedSlot, customer: customer)
    }
    
    func didSelectChangeToUser() {
        showUserMainScreen()
    }
    
    func didSelectBlockedUsers() {
        showBlockedUsersScreen()
    }
}

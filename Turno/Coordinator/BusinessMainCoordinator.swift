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
    private let networkManager: NetworkManagerProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    
    init(window: UIWindow = UIWindow(),
         navigationController: UINavigationController = UINavigationController(),
         networkManager: NetworkManagerProtocol,
         analyticsManager: AnalyticsManagerProtocol) {
        self.window = window
        self.navigationController = navigationController
        self.networkManager = networkManager
        self.analyticsManager = analyticsManager
    }
    
    func start() {}
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
        let screen = ScreenFactory.makeAddAppointmentScreen(networkManager: networkManager,
                                                            analyticsManager: analyticsManager,
                                                            delegate: delegate,
                                                            modelBusiness: modelBusiness)
        pushViewByHomeInnerViewController(screen: screen)
    }
    
    func showAppointmentScreen(turn: Turn) {
        let confirmationScreenModel = ConfirmationScreenModel(userId: turn.userId,
                                                              name: turn.userName,
                                                              turnId: turn.identifier,
                                                              bookedServices: turn.services,
                                                              bookedSlot: EmptySlot(slot: turn.dateTimeUTC, selected: true),
                                                              confirmationViewType: .business,
                                                              customer: Customer(name: turn.userName, phoneNumber: turn.userPhone))
        let screen = ScreenFactory.makeConfirmationScreen(networkManager: networkManager,
                                                          analyticsManager: analyticsManager,
                                                          delegate: self,
                                                          confirmationScreenModel: confirmationScreenModel)
        pushViewByHomeInnerViewController(screen: screen)
    }
    
    func showCheckAvailabilityScreen(identifier: String?,
                                     name: String?,
                                     bookedServices: [Service]?,
                                     modelCheckTurnsAvailability: ModelCheckTurnsAvailability?,
                                     customer: Customer?) {
        let screen = ScreenFactory.makeCheckAvailabilityScreen(networkManager: networkManager,
                                                               analyticsManager: analyticsManager,
                                                               delegate: self,
                                                               identifier: identifier,
                                                               name: name,
                                                               bookedServices: bookedServices,
                                                               modelCheckTurnsAvailability: modelCheckTurnsAvailability,
                                                               customer: customer)
        pushViewByHomeInnerViewController(screen: screen)
    }
    
    func showConfirmationScreen(userId: String?, name: String?, turnId: String?,
                                bookedServices: [Service]?, bookedSlot: EmptySlot?, customer: Customer?) {
        let confirmationScreenModel = ConfirmationScreenModel(userId: userId,
                                                              name: name,
                                                              turnId: turnId,
                                                              bookedServices: bookedServices,
                                                              bookedSlot: bookedSlot,
                                                              confirmationViewType: .user,
                                                              customer: customer)
        let screen = ScreenFactory.makeConfirmationScreen(networkManager: networkManager,
                                                          analyticsManager: analyticsManager,
                                                          delegate: self,
                                                          confirmationScreenModel: confirmationScreenModel)
        pushViewByHomeInnerViewController(screen: screen)
    }
    
    func showUserMainScreen() {
        NotificationCenter.default.post(name: Settings.changeToUser, object: nil, userInfo: nil)
    }
    
    func showBlockedUsersScreen() {
        let screen = ScreenFactory.makeBlockedUsersScreen(networkManager: networkManager,
                                                          analyticsManager: analyticsManager,
                                                          delegate: self)
        pushViewBySettingsInnerViewController(screen: screen)
    }
    
    func showWebViewController(for type: WebViewType) {
        let screen = ScreenFactory.makeWebViewScreen(webViewType: type)
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
        showCheckAvailabilityScreen(identifier: identifier,
                                    name: name,
                                    bookedServices: bookedServices,
                                    modelCheckTurnsAvailability: modelCheckTurnsAvailability,
                                    customer: customer)
    }
    
    func didSelectConfirm(identifier: String?,
                          name: String?,
                          bookedServices: [Service]?,
                          bookedSlot: EmptySlot?,
                          customer: Customer?) {
        showConfirmationScreen(userId: identifier,
                               name: name,
                               turnId: nil,
                               bookedServices: bookedServices,
                               bookedSlot: bookedSlot,
                               customer: customer)
    }
    
    func didSelectChangeToUser() {
        showUserMainScreen()
    }
    
    func didSelectBlockedUsers() {
        showBlockedUsersScreen()
    }
    
    func didSelectSettingsType(webViewType: WebViewType) {
        showWebViewController(for: webViewType)
    }
}

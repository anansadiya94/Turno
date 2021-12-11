//
//  MainCoordinator.swift
//  Turno
//
//  Created by Anan Sadiya on 18/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class UserMainCoordinator: Coordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let networkManager: NetworkManagerProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    private let forceUpdateManager: ForceUpdateManagerProtocol
    
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
    }
    
    func start() {}
}

extension UserMainCoordinator {
    func pushViewByHomeInnerViewController(screen: UIViewController) {
        if let mainVC = navigationController.viewControllers[0] as? UserMainViewController {
            mainVC.selectedIndex = 0
            if let homeVC = mainVC.viewControllers?[0] as? UINavigationController {
                homeVC.pushViewController(screen, animated: true)
            }
        }
    }
    
    func pushViewBySettingsInnerViewController(screen: UIViewController) {
        if let mainVC = navigationController.viewControllers[0] as? UserMainViewController {
            if let settingsVC = mainVC.viewControllers?[3] as? UINavigationController {
                settingsVC.pushViewController(screen, animated: true)
            }
        }
    }
    
    func showBusinessScreen(model: ModelBusiness) {
        let screen = ScreenFactory.makeBusinessScreen(networkManager: networkManager,
                                                      analyticsManager: analyticsManager,
                                                      delegate: self,
                                                      model: model)
        pushViewByHomeInnerViewController(screen: screen)
    }
    
    func makeCheckAvailabilityScreen(identifier: String?,
                                     name: String?,
                                     bookedServices: [Service]?,
                                     modelCheckTurnsAvailability: ModelCheckTurnsAvailability?) {
        let screen = ScreenFactory.makeCheckAvailabilityScreen(networkManager: networkManager,
                                                               analyticsManager: analyticsManager,
                                                               delegate: self,
                                                               identifier: identifier,
                                                               name: name,
                                                               bookedServices: bookedServices,
                                                               modelCheckTurnsAvailability: modelCheckTurnsAvailability)
        pushViewByHomeInnerViewController(screen: screen)
    }
    
    func showConfirmationScreen(identifier: String?, name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?) {
        let screen = ScreenFactory.makeConfirmationScreen(networkManager: networkManager,
                                                          analyticsManager: analyticsManager,
                                                          delegate: self,
                                                          identifier: identifier,
                                                          name: name,
                                                          bookedServices: bookedServices,
                                                          bookedSlot: bookedSlot,
                                                          confirmationViewType: .user)
        pushViewByHomeInnerViewController(screen: screen)
    }
    
    func showBusinessMainScreen() {
        NotificationCenter.default.post(name: Settings.changeToBusiness, object: nil, userInfo: nil)
    }
    
    func showWebViewController(for type: WebViewType) {
        let screen = ScreenFactory.makeWebViewScreen(webViewType: type)
        pushViewBySettingsInnerViewController(screen: screen)
    }
}

extension UserMainCoordinator: SelectButtonEntity {
    func didSelectEntity(model: ModelBusiness) {
        showBusinessScreen(model: model)
    }
    
    func didSelectCheckAvailability(identifier: String?,
                                    name: String?,
                                    bookedServices: [Service]?,
                                    modelCheckTurnsAvailability: ModelCheckTurnsAvailability?) {
        makeCheckAvailabilityScreen(identifier: identifier,
                                    name: name,
                                    bookedServices: bookedServices,
                                    modelCheckTurnsAvailability: modelCheckTurnsAvailability)
    }
    
    func didSelectConfirm(identifier: String?, name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?) {
        showConfirmationScreen(identifier: identifier, name: name, bookedServices: bookedServices, bookedSlot: bookedSlot)
    }
    
    func didSelectChangeToBusiness() {
        showBusinessMainScreen()
    }
    
    func didSelectSettingsType(webViewType: WebViewType) {
        showWebViewController(for: webViewType)
    }
}

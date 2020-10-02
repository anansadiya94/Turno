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
    
    init(window: UIWindow = UIWindow(), navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
    }
}

extension UserMainCoordinator {
    func pushViewByExploreInnerViewController(screen: UIViewController) {
        if let mainVC = navigationController.viewControllers[0] as? UserMainViewController {
            if let exploreVC = mainVC.viewControllers?[0] as? UINavigationController {
                exploreVC.pushViewController(screen, animated: true)
            }
        }
    }
    
    func showBusinessScreen(model: ModelBusiness) {
        let screen = ScreenFactory.makeBusinessScreen(delegate: self, model: model)
        pushViewByExploreInnerViewController(screen: screen)
    }
    
    func makeCheckAvailabilityScreen(identifier: String?, name: String?, bookedServices: [Service]?,
                                     modelCheckTurnsAvailability: ModelCheckTurnsAvailability?) {
        let screen = ScreenFactory.makeCheckAvailabilityScreen(delegate: self, identifier: identifier, name: name,
                                                               bookedServices: bookedServices,
                                                               modelCheckTurnsAvailability: modelCheckTurnsAvailability)
        pushViewByExploreInnerViewController(screen: screen)
    }
    
    func showConfirmationScreen(identifier: String?, name: String?, bookedServices: [Service]?,
                                bookedSlot: EmptySlot?) {
        let screen = ScreenFactory.makeConfirmationScreen(delegate: self,
                                                          identifier: identifier,
                                                          name: name,
                                                          bookedServices: bookedServices,
                                                          bookedSlot: bookedSlot,
                                                          confirmationViewType: .user)
        pushViewByExploreInnerViewController(screen: screen)
    }
}

extension UserMainCoordinator: SelectButtonEntity {
    func didSelectEntity(model: ModelBusiness) {
        showBusinessScreen(model: model)
    }
    
    func didSelectCheckAvailability(identifier: String?, name: String?, bookedServices: [Service]?,
                                    modelCheckTurnsAvailability: ModelCheckTurnsAvailability?) {
        makeCheckAvailabilityScreen(identifier: identifier, name: name, bookedServices: bookedServices,
                                    modelCheckTurnsAvailability: modelCheckTurnsAvailability)
    }
    
    func didSelectConfirm(identifier: String?, name: String?, bookedServices: [Service]?, bookedSlot: EmptySlot?) {
        showConfirmationScreen(identifier: identifier, name: name, bookedServices: bookedServices, bookedSlot: bookedSlot)
    }
}

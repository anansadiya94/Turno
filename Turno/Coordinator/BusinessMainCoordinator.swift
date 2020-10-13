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
    func pushViewByExploreInnerViewController(screen: UIViewController) {
        if let mainVC = navigationController.viewControllers[0] as? BusinessMainViewController {
            if let exploreVC = mainVC.viewControllers?[0] as? UINavigationController {
                exploreVC.pushViewController(screen, animated: true)
            }
        }
    }
    
    func showAddAppointmentScreen(modelBusiness: ModelBusiness?, delegate: SelectButtonBusiness) {
        let screen = ScreenFactory.makeAddAppointmentScreen(modelBusiness: modelBusiness, delegate: delegate)
        pushViewByExploreInnerViewController(screen: screen)
    }
    
    func showAppointmentScreen(turn: Turn) {
        let screen = ScreenFactory.makeConfirmationScreen(delegate: self,
                                                          identifier: turn.identifier,
                                                          name: "TODO",
                                                          bookedServices: turn.services,
                                                          bookedSlot: EmptySlot(slot: turn.dateTimeUTC, selected: true),
                                                          confirmationViewType: .business)
        pushViewByExploreInnerViewController(screen: screen)
    }
}

extension BusinessMainCoordinator: SelectButtonBusiness {
    func addAppointmentTapped(modelBusiness: ModelBusiness?) {
        showAddAppointmentScreen(modelBusiness: modelBusiness, delegate: self)
    }
    
    func showAppointmentTapped(turn: Turn) {
        showAppointmentScreen(turn: turn)
    }
}

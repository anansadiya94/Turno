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
    
    func showAddAppointmentScreen(delegate: SelectButtonBusiness) {
        let screen = ScreenFactory.makeAddAppointmentScreen(delegate: delegate)
        pushViewByExploreInnerViewController(screen: screen)
    }
    
    func showAppointmentScreen() {
        let vc = UIViewController()
        vc.view.backgroundColor = .green
        pushViewByExploreInnerViewController(screen: vc)
    }
}

extension BusinessMainCoordinator: SelectButtonBusiness {
    func addAppointmentTapped() {
        showAddAppointmentScreen(delegate: self)
    }
    
    func showAppointmentTapped() {
        showAppointmentScreen()
    }
}

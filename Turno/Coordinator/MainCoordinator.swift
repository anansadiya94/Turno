//
//  MainCoordinator.swift
//  Turno
//
//  Created by Anan Sadiya on 18/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow = UIWindow(), navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
    }
}

extension MainCoordinator {
    
    func pushViewByExploreInnerViewController(screen: UIViewController) {
        if let mainVC = navigationController.viewControllers[0] as? MainViewController {
            if let exploreVC = mainVC.viewControllers?[0] as? UINavigationController {
                exploreVC.pushViewController(screen, animated: true)
            }
        }
    }
    
    func showBusinessScreen(model: ModelBusiness) {
        let screen = ScreenFactory.makeBusinessScreen(delegate: self, model: model)
        pushViewByExploreInnerViewController(screen: screen)
    }
}

extension MainCoordinator: SelectButtonEntity {
    func didSelectEntity(model: ModelBusiness) {
        showBusinessScreen(model: model)
    }
}

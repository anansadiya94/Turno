//
//  AppCoordinator.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    var starterCoordinator: Coordinator?
    private let networkManager: NetworkManagerProtocol
    
    init(window: UIWindow = UIWindow(), navigationController: UINavigationController = UINavigationController(), networkManager: NetworkManagerProtocol) {
        self.window = window
        self.navigationController = navigationController
        self.networkManager = networkManager
        setupWindow()
        setupStarterCoordinator()
    }
    
    func setupWindow() {
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func setupStarterCoordinator() {
        starterCoordinator = OnBoardingCoordinator(window: window, navigationController: navigationController, networkManager: networkManager)
    }
    
    func start() {
        starterCoordinator?.start()
    }
}

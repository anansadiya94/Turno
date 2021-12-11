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
    private var starterCoordinator: Coordinator?
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
        setupWindow()
        setupStarterCoordinator()
    }
    
    func setupWindow() {
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func setupStarterCoordinator() {
        starterCoordinator = OnBoardingCoordinator(window: window,
                                                   navigationController: navigationController,
                                                   networkManager: networkManager,
                                                   analyticsManager: analyticsManager,
                                                   forceUpdateManager: forceUpdateManager)
    }
    
    func start() {
        starterCoordinator?.start()
    }
}

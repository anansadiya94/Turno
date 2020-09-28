//
//  BusinessMainViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class BusinessMainViewController: UITabBarController {
    
    // MARK: - Properties
    var presenterMain: PresenterBusinessMain!
    private var homeTabBarItem = UITabBarItem()
    private var settingsTabBarItem = UITabBarItem()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configureUI()
    }
    
    // MARK: - Private functions
    private func configureUI() {
        setTabBarItems()
        setTabBar()
    }
    
    private func setTabBarItems() {
        homeTabBarItem.image = UIImage(systemName: "house")
        settingsTabBarItem.image = UIImage(systemName: "gear")
    }
    
    private func setTabBar() {
        let tabBarItems = [homeTabBarItem, settingsTabBarItem]
        tabBar.tintColor = .primary
        guard let viewControllers = self.viewControllers else { return }
        for (viewController, tabBarItem) in zip(viewControllers, tabBarItems) {
            viewController.tabBarItem = tabBarItem
        }
    }
}

//
//  MainViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class UserMainViewController: UITabBarController {
    
    // MARK: - Properties
    var presenterMain: PresenterUserMain!
    private var homeTabBarItem = UITabBarItem()
    private var appointmentsTabBarItem = UITabBarItem()
    private var favoritesTabBarItem = UITabBarItem()
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
        appointmentsTabBarItem.image = UIImage(systemName: "calendar")
        favoritesTabBarItem.image = UIImage(systemName: "heart")
        settingsTabBarItem.image = UIImage(systemName: "gear")
    }
    
    private func setTabBar() {
        let tabBarItems = [homeTabBarItem, appointmentsTabBarItem, favoritesTabBarItem, settingsTabBarItem]
        tabBar.tintColor = .primary
        guard let viewControllers = self.viewControllers else { return }
        for (viewController, tabBarItem) in zip(viewControllers, tabBarItems) {
            viewController.tabBarItem = tabBarItem
        }
    }
}

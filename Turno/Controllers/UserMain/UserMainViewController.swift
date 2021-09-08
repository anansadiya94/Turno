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
    
    let tabBarDictionary: [Int: TabBarModel] = [0: TabBarModel(name: LocalizedConstants.home_key.enLocalized,
                                                               imageName: "house"),
                                                1: TabBarModel(name: LocalizedConstants.my_turns_key.enLocalized,
                                                               imageName: "calendar"),
                                                2: TabBarModel(name: LocalizedConstants.favorites_key.enLocalized,
                                                               imageName: "heart"),
                                                3: TabBarModel(name: LocalizedConstants.settings_key.enLocalized,
                                                               imageName: "gear")]
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configureUI()        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let currentTag = selectedViewController?.tabBarItem.tag {
            presenterMain.tabBarDidSelect(currentTabName: tabBarDictionary[currentTag]?.name ?? "",
                                          tappedTabName: tabBarDictionary[item.tag]?.name ?? "")
        }
    }
    
    // MARK: - Private functions
    private func configureUI() {
        setTabBarItems()
        setTabBar()
    }
    
    private func setTabBarItems() {
        homeTabBarItem.tag = 0
        if let imageName = tabBarDictionary[0]?.imageName {
            homeTabBarItem.image = UIImage(systemName: imageName)
        }
        
        appointmentsTabBarItem.tag = 1
        if let imageName = tabBarDictionary[1]?.imageName {
            appointmentsTabBarItem.image = UIImage(systemName: imageName)
        }
        
        favoritesTabBarItem.tag = 2
        if let imageName = tabBarDictionary[2]?.imageName {
            favoritesTabBarItem.image = UIImage(systemName: imageName)
        }
        
        settingsTabBarItem.tag = 3
        if let imageName = tabBarDictionary[3]?.imageName {
            settingsTabBarItem.image = UIImage(systemName: imageName)
        }
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

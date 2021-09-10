//
//  BusinessMainViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

struct TabBarModel {
    let name: String
    let imageName: String
}

class BusinessMainViewController: UITabBarController {
    
    // MARK: - Properties
    var presenterMain: PresenterBusinessMain!
    private var homeTabBarItem = UITabBarItem()
    private var settingsTabBarItem = UITabBarItem()
    
    let tabBarDictionary: [Int: TabBarModel] = [0: TabBarModel(name: LocalizedConstants.home_key.enLocalized,
                                                               imageName: "house"),
                                                1: TabBarModel(name: LocalizedConstants.settings_key.enLocalized,
                                                               imageName: "gear")]
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configureUI()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let currentTag = selectedViewController?.tabBarItem.tag {
            presenterMain.tabBarDidSelect(previousTabName: tabBarDictionary[currentTag]?.name ?? "",
                                          currentTabName: tabBarDictionary[item.tag]?.name ?? "")
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
        
        settingsTabBarItem.tag = 1
        if let imageName = tabBarDictionary[1]?.imageName {
            settingsTabBarItem.image = UIImage(systemName: imageName)
        }
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

//
//  AppDelegate.swift
//  Turno
//
//  Created by Anan Sadiya on 01/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private let analyticsManager: AnalyticsManagerProtocol = AnalyticsManager()
    private let forceUpdateManager: ForceUpdateManager = ForceUpdateManager()
    
    private var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        forceUpdateManager.networkManager = networkManager
        setAppFont()
        trackDeviceLanguage()
        appCoordinator = AppCoordinator(window: window!,
                                        navigationController: UINavigationController(),
                                        networkManager: networkManager,
                                        analyticsManager: analyticsManager,
                                        forceUpdateManager: forceUpdateManager)
        appCoordinator?.start()
        
        FirebaseApp.configure()
        
        if Preferences.getPrefsUser()?.userId != nil {
            let pushManager = PushNotificationManager(networkManager: networkManager,
                                                      analyticsManager: analyticsManager)
            pushManager.registerForPushNotifications()
        }
        
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        analyticsManager.track(eventKey: .appMovedToBackground, withProperties: nil)
    }
    
    private func setAppFont() {
        let language = Locale.current.languageCode
        if language == "ar" {
            AppData.appFont = "Cairo"
        } else if language == "he" {
            AppData.appFont = "Assistant"
        } else {
            AppData.appFont = "OpenSans"
        }
    }
    
    private func trackDeviceLanguage() {
        analyticsManager.peopleSet(properties: [
            AnalyticsPeoplePropertyKeys.deviceLanguage: Locale.current.languageCode?.capitalized
        ])
    }
}

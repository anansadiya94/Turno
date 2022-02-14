//
//  AppDelegate.swift
//  Turno
//
//  Created by Anan Sadiya on 01/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Firebase
import AppTrackingTransparency

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
        
        if Preferences.getPrefsUser()?.userId != nil {
            let pushManager = PushNotificationManager(networkManager: networkManager,
                                                      analyticsManager: analyticsManager)
            pushManager.registerForPushNotifications()
        }
        
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        DispatchQueue.main.async { [weak self] in
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { [weak self] status in
                    DispatchQueue.main.async {
                        if case .authorized = status {
                            self?.configureFirebase()
                        } else {
                            self?.analyticsManager.removeInstance()
                        }
                    }
                })
            } else {
                self?.configureFirebase()
            }
        }
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
    
    private func configureFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

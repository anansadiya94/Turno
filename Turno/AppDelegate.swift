//
//  AppDelegate.swift
//  Turno
//
//  Created by Anan Sadiya on 01/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.Message_ID"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        setAppFont()
        let appCoordinator: AppCoordinator!
        appCoordinator = AppCoordinator(window: window!, navigationController: UINavigationController())
        appCoordinator.start()
        
        FirebaseApp.configure()
        
        let pushManager = PushNotificationManager()
        pushManager.registerForPushNotifications()
        
        window?.makeKeyAndVisible()
        return true
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
}

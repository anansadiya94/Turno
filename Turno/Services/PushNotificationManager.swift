//
//  PushNotificationManager.swift
//  Turno
//
//  Created by Anan Sadiya on 18/03/2021.
//  Copyright © 2021 Anan Sadiya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

class PushNotificationManager: NSObject {
    let gcmMessageIDKey = "gcm.Message_ID"
    private let networkManager: NetworkManagerProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    
    init(networkManager: NetworkManagerProtocol,
         analyticsManager: AnalyticsManagerProtocol) {
        self.networkManager = networkManager
        self.analyticsManager = analyticsManager
        super.init()
        trackNotificationSettingsAuthorizationStatus()
    }
    
    func trackNotificationSettingsAuthorizationStatus() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { [weak self] settings in
            switch settings.authorizationStatus {
            case .authorized:
                self?.analyticsManager.peopleSet(properties: [AnalyticsPeoplePropertyKeys.pushNotificationOptIn: "true"])
            default:
                self?.analyticsManager.peopleSet(properties: [AnalyticsPeoplePropertyKeys.pushNotificationOptIn: "false"])
            }
        })
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {[weak self] _, _ in
            self?.trackNotificationSettingsAuthorizationStatus()
        })
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }
    
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            networkManager.registerFCMToken(modelFcmTokenTask: ModelFcmTokenTask(fcmToken: token)) { [weak self] result, error in
                if let error = error {
                    print("Error while registering FCM token with \(error.localizedDescription)")
                }
                if let result = result {
                    if result {
                        self?.analyticsManager.peopleSet(properties: [AnalyticsPeoplePropertyKeys.firebaseToken: Messaging.messaging().fcmToken])
                        print("FCM token was registered successfully.")
                    } else {
                        print("FCM token was not registered successfully.")
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

// MARK: - MessagingDelegate
extension PushNotificationManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        updateFirestorePushTokenIfNeeded()
    }
}
// MARK: - UNUserNotificationCenterDelegate
@available(iOS 10, *)
extension PushNotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        completionHandler([[.list, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

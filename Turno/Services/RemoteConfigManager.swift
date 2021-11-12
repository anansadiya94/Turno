//
//  RemoteConfigManager.swift
//  Turno
//
//  Created by Anan Sadiya on 13/09/2021.
//  Copyright © 2021 Anan Sadiya. All rights reserved.
//

import Foundation
import Firebase

struct RemoteConfigManager {
    
    private static var remoteConfig: RemoteConfig = {
        var remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        return remoteConfig
    }()
    
    private struct Constants {
        static let forceUpdateFireBaseKey = "force_update_current_version_ios"
        static let shortVersionBundleKey = "CFBundleShortVersionString"
    }
    
    static func configure(expirationDuration: TimeInterval = 0.0) {
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { _, error in
            if let error = error {
                print(error)
            }
            RemoteConfigManager.remoteConfig.activate(completion: nil)
        }
    }
    
    static func shouldForceUpdate() -> Bool {
        return forceUpdateValue()
    }
    
    static func forceUpdateValue() -> Bool {
        guard let forceUpdateVersion = RemoteConfigManager.remoteConfig[Constants.forceUpdateFireBaseKey].stringValue,
              let currentVersion = Bundle.main.infoDictionary?[Constants.shortVersionBundleKey] as? String else {
            return false
        }
        return currentVersion.compare(forceUpdateVersion, options: .numeric) == .orderedAscending
    }
}

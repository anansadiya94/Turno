//
//  Preferences.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class Preferences {
    
    // MARK: - AppState
    
    /// Returns the preferences value associated with the key kPrefsAppState.
    /// - returns: The string containing app state.
    static func getPrefsAppState() -> AppState? {
        guard let state = UserDefaults.standard.value(forKey: kPrefsAppState) as? String else {
            return nil
        }
        return AppState(rawValue: state)
    }
    
    /// Sets the value associated with the key kPrefsAppState.
    /// - parameter value: The new value.
    static func setPrefsAppState(value: AppState) {
        UserDefaults.standard.set(value.rawValue, forKey: kPrefsAppState)
    }
    
    /// Delete the value associated with the key kPrefsAppState
    static func removePrefsAppState() {
        UserDefaults.standard.removeObject(forKey: kPrefsAppState)
    }
    
    // MARK: - User
    
    /// Sets the value associated with the key kPrefsUser.
    /// - parameter value: The new value.
    static func setPrefsUser(user: User?) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: kPrefsUser)
    }
    
    /// Returns the preferences value associated with the key kPrefsUser.
    /// - returns: The string containing the token.
    static func getPrefsUser() -> User? {
        if let userData = UserDefaults.standard.value(forKey: kPrefsUser) as? Data {
            return try? PropertyListDecoder().decode(User.self, from: userData)
        }
    
        return nil
    }
    
    /// Delete the preferences value associated with the key kPrefsUser.
    static func removePrefsUser() {
        UserDefaults.standard.removeObject(forKey: kPrefsUser)
    }
    
    static func getAuthorization() -> String {
        if let userId = Preferences.getPrefsUser()?.userId, let secret = Preferences.getPrefsUser()?.secret {
            let authorization = userId + ":" + secret
            let authorizationBase64 = Data(authorization.utf8).base64EncodedString()
            return "Basic " + authorizationBase64
        }
        return ""
    }
}

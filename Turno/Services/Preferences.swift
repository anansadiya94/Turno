//
//  Preferences.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class Preferences {
    
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
}

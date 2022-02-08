//
//  ForceUpdateManager.swift
//  Turno
//
//  Created by Anan Sadiya on 11/12/2021.
//  Copyright © 2021 Anan Sadiya. All rights reserved.
//

import Foundation

protocol ForceUpdateManagerProtocol {
    func shouldForceUpdate(completion: @escaping (Bool) -> Void)
}

class ForceUpdateManager: ForceUpdateManagerProtocol {
    var networkManager: NetworkManagerProtocol?
    
    private struct Constants {
        static let shortVersionBundleKey = "CFBundleShortVersionString"
    }
    
    func shouldForceUpdate(completion: @escaping (Bool) -> Void) {
        guard let currentVersion = Bundle.main.infoDictionary?[Constants.shortVersionBundleKey] as? String else {
            completion(false)
            return
        }
        
        let modelForceUpdateTask = ModelForceUpdateTask(currentVersion: currentVersion, osType: 0)
        shouldForceUpdate(modelForceUpdateTask: modelForceUpdateTask, completion: completion)
    }
    
    func shouldForceUpdate(modelForceUpdateTask: ModelForceUpdateTask, completion: @escaping (Bool) -> Void) {
        
        networkManager?.shouldForceUpdate(modelForceUpdateTask: modelForceUpdateTask) { shouldForceUpdate, error in
            guard let shouldForceUpdate = shouldForceUpdate else {
                print(error?.localizedDescription ?? "")
                completion(false)
                return
            }
            completion(shouldForceUpdate)
        }
    }
}

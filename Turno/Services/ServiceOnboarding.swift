//
//  ServiceOnboarding.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class ServiceOnboarding {
    
    // MARK: - Private functions
    static private func fetchDataWithNetwork(callback: ([ModelOnboarding]) -> Void) {
        callback([ModelOnboarding]())
    }
    
    static func fetchDataWithoutNetwork() -> [ModelOnboarding] {
        let firstOnboarding = ModelOnboarding(id: 1, backgroungImage: kFirstOnboardingBackgroundImage,
                                              title: LocalizedConstants.first_onboarding_title_key.localized,
                                              subTitle: LocalizedConstants.first_onboarding_subtitle_key.localized,
                                              actionTitle: LocalizedConstants.next_key.localized,
                                              amILast: false)
        let secondOnboarding = ModelOnboarding(id: 2, backgroungImage: kSecondOnboardingBackgroundImage,
                                               title: LocalizedConstants.second_onboarding_title_key.localized,
                                               subTitle: LocalizedConstants.second_onboarding_subtitle_key.localized,
                                               actionTitle: LocalizedConstants.next_key.localized,
                                               amILast: false)
        let thirdOnboarding = ModelOnboarding(id: 3, backgroungImage: kThirdOnboardingBackgroundImage,
                                              title: LocalizedConstants.third_onboarding_title_key.localized,
                                              subTitle: LocalizedConstants.third_onboarding_subtitle_key.localized,
                                              actionTitle: LocalizedConstants.done_key.localized,
                                              amILast: true)
        return [firstOnboarding, secondOnboarding, thirdOnboarding]
    }
    
    // MARK: - Public Interface
    static func fetchData(callback: @escaping ([ModelOnboarding]) -> Void, withNetwork: Bool) {
        if withNetwork {
            fetchDataWithNetwork { (modelOnboarding) in
                callback(modelOnboarding)
            }
        } else {
            DispatchQueue.main.async(execute: {
               callback(fetchDataWithoutNetwork())
            })
        }
    }
}

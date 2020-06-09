//
//  UIApplication+AppConstants.swift
//  Turno
//
//  Created by Anan Sadiya on 09/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

extension UIApplication {
    static var privacyPolicyUrl: String? {
        return Bundle.main.object(forInfoDictionaryKey: "PrivacyPolicyUrl") as? String
    }
}

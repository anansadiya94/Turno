//
//  UIViewController+CallNumber.swift
//  Turno
//
//  Created by Anan Sadiya on 22/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func callNumber(_ phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application: UIApplication = UIApplication.shared
            if application.canOpenURL(phoneCallURL) == true {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                // TODO: SHOW ERROR ALERT?
                print("ERROR PHONE NUMBER")
            }
        }
    }
}

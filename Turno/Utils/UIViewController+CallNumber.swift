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
                let alert = UIAlertController(title: LocalizedConstants.generic_error_title_key.localized,
                                              message: LocalizedConstants.generic_error_message_key.localized,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: LocalizedConstants.ok_key.localized,
                                              style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

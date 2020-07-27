//
//  UIViewController+MapOptions.swift
//  Turno
//
//  Created by Anan Sadiya on 22/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func openMaps(model: ModelLocation) {
        guard let lat = model.location.lat, let lng = model.location.lng else { return }
        let appleURL = "http://maps.apple.com/?daddr=\(String(describing: lat)),\(String(describing: lng))"
        let googleURL = "comgooglemaps://?daddr=\(String(describing: lat)),\(String(describing: lng))&directionsmode=driving"

        var installedNavigationApps = [(LocalizedConstants.open_in_key.localized + " Apple Maps", URL(string: appleURL)!)]
        let googleItem = (LocalizedConstants.open_in_key.localized + " Google Map", URL(string: googleURL)!)

        if UIApplication.shared.canOpenURL(googleItem.1) {
            installedNavigationApps.append(googleItem)
        }

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for app in installedNavigationApps {
            let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            alert.addAction(button)
        }
        let cancel = UIAlertAction(title: LocalizedConstants.cancel_key.localized, style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

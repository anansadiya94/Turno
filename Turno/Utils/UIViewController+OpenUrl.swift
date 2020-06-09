//
//  UIViewController+OpenUrl.swift
//  Turno
//
//  Created by Anan Sadiya on 09/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

extension UIViewController {
    func openUrl(_ websiteUrl: String) {
        let validWebsiteUrlString = websiteUrl.hasPrefix("http") ? websiteUrl : "http://\(websiteUrl)"
        if let url = URL(string: validWebsiteUrlString) {
            UIApplication.shared.open(url)
        }
    }
}

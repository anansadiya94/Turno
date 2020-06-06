//
//  UIViewController+SetBackBarButton.swift
//  Turno
//
//  Created by Anan Sadiya on 05/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

extension UIViewController {
    func setBackBarButton() {
        self.navigationController?.navigationBar.tintColor = .primary
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

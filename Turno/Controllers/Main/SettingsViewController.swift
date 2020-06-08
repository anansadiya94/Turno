//
//  SettingsViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setNavigationBar()
    }
    
    // MARK: - Private methods
    private func setNavigationBar() {
        navigationItem.title = LocalizedConstants.settings_key.localized
    }
}

//
//  AppointmentsViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class AppointmentsViewController: UIViewController {

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        setNavigationBar()
    }
        
    // MARK: - Private methods
    private func setNavigationBar() {
        navigationItem.title = LocalizedConstants.my_turns_key.localized
    }
}

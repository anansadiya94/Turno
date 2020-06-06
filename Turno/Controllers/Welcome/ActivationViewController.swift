//
//  ActivationViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

class ActivationViewController: UIViewController {
    
    // MARK: - Properties
    var presenterActivation: PresenterActivation!
    var activationView: ActivationView?
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setWelcomeView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    // MARK: - Private methods
    private func setNavigationBar() {
        navigationItem.title = LocalizedConstants.activate_your_account_key.localized
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setWelcomeView() {
        activationView = ActivationView(frame: view.frame)
        self.view = activationView
    }
}

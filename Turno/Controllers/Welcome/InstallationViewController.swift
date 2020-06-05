//
//  InstallationViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 05/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

class InstallationViewController: UIViewController {
    
    // MARK: - Properties
    var presenterInstallation: PresenterInstallation!
    var installationView: InstallationView?
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setWelcomeView()
        addTargets()
    }
    
    // MARK: - Private methods
    private func setWelcomeView() {
        installationView = InstallationView(frame: view.frame)
        self.view = installationView
    }
    
    private func addTargets() {
        installationView?.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - UI interaction methods
    @objc func continueButtonTapped(sender: UIButton) {
        presenterInstallation.continueButtonTapped()
    }
}

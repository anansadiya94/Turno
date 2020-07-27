//
//  WelcomeViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 04/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class WelcomeViewController: ParentViewController {
    
    // MARK: - Properties
    var presenterWelcome: PresenterWelcome!
    var welcomeView: WelcomeView?
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setWelcomeView()
        addTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Private methods
    private func setWelcomeView() {
        welcomeView = WelcomeView(frame: view.frame)
        self.view = welcomeView
    }
    
    private func addTargets() {
        welcomeView?.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        welcomeView?.privacyPolicyButton.addTarget(self, action: #selector(privacyPolicyButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - UI interaction methods
    @objc func continueButtonTapped(sender: UIButton) {
        presenterWelcome.continueButtonTapped()
    }
    
    @objc func privacyPolicyButtonTapped(sender: UIButton) {
        presenterWelcome.privacyPolicyButtonTapped()
    }
}

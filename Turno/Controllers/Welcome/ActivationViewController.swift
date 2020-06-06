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
    
    let progress = Progress(totalUnitCount: 10)
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setWelcomeView()
        addTargets()
        configureProgressView()
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
    
    private func addTargets() {
        activationView?.wrongNumberButton.addTarget(self, action: #selector(wrongNumberButtonTapped), for: .touchUpInside)
        activationView?.resendSMSButton.addTarget(self, action: #selector(resendSMSButtonTapped), for: .touchUpInside)
        activationView?.activateByCallButton.addTarget(self, action: #selector(activateByCallButtonTapped), for: .touchUpInside)
    }
    
    private func configureProgressView() {
        startCount()
    }

    private func startCount() {
        activationView?.progressView.progress = 0.0
        progress.completedUnitCount = 0

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            guard self.progress.isFinished == false else {
                timer.invalidate()
                //TODO When finished?
                return
            }
            self.progress.completedUnitCount += 1
            self.activationView?.progressView.setProgress(Float(self.progress.fractionCompleted), animated: true)
        }
    }
    
    // MARK: - UI interaction methods
    @objc func wrongNumberButtonTapped() {
        presenterActivation.wrongNumberButtonTapped()
    }
    
    @objc func resendSMSButtonTapped() {
        presenterActivation.resendSMSButtonTapped()
    }
    
    @objc func activateByCallButtonTapped() {
        presenterActivation.activateByCallButtonTapped()
    }
}

// MARK: - PresenterActivationView methods
extension ActivationViewController: PresenterActivationView {
    func popViewController() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

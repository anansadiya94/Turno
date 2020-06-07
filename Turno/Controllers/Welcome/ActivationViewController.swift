//
//  ActivationViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

let kSeconds: Int = 10

class ActivationViewController: UIViewController {
    
    // MARK: - Properties
    var presenterActivation: PresenterActivation!
    var activationView: ActivationView?
    
    let progress = Progress(totalUnitCount: Int64(kSeconds))
    var seconds: Double = Double(kSeconds)
    var start: Float = 0
    var timer: Timer?
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setWelcomeView()
        addTargets()
        fireTimer()
        configureOPTView()
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
        activationView?.finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
    }
    
    private func fireTimer() {
        activationView?.progressView.progress = 0.0
        progress.completedUnitCount = 0
        progress.totalUnitCount = Int64(kSeconds)

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
            if self.start <= Float(kSeconds) {
                // Progress view
                self.start += 0.01
                self.activationView?.progressView.setProgress(self.start/Float(10), animated: true)
                // Count down label
                self.seconds -= 0.01
                self.activationView?.updateCountDownLabel(time: self.seconds.rounded(toPlaces: 2))
            } else {
                timer.invalidate()
                self.activationView?.updateCountDownLabel(time: 0.00)
                //TODO When finished?
                return
            }
        }
    }
    
    private func configureOPTView() {
        activationView?.otpStackView.delegate = self
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
    
    @objc func finishButtonTapped() {
        presenterActivation.finishButtonTapped()
    }
}

// MARK: - PresenterActivationView methods
extension ActivationViewController: PresenterActivationView {
    func popViewController() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ActivationViewController methods
extension ActivationViewController: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        if isValid, let otp = activationView?.otpStackView.getOTP() {
            timer?.invalidate()
            print("Code is: \(otp)")
        }
    }
}

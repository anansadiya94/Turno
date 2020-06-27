//
//  ActivationViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

class ActivationViewController: ParentViewController {
    
    // MARK: - Properties
    var presenterActivation: PresenterActivation!
    var activationView: ActivationView?
    
    var progress = Progress(totalUnitCount: Int64(0))
    var seconds: Double = Double(0)
    var start: Float = 0
    var timer: Timer?
    
    override var navBarTitle: String {
        return LocalizedConstants.activate_your_account_key.localized
    }
    
    override var isNavBarBackButtonHidden: Bool {
        return true
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setActivationView()
        addTargets()
        configureOTPView()
    }
    
    // MARK: - Private methods
    private func setActivationView() {
        activationView = ActivationView(frame: view.frame)
        self.view = activationView
    }
    
    private func addTargets() {
        activationView?.wrongNumberButton.addTarget(self, action: #selector(wrongNumberButtonTapped), for: .touchUpInside)
        activationView?.resendSMSButton.addTarget(self, action: #selector(resendSMSButtonTapped), for: .touchUpInside)
    }
    
    private func fireTimer(_ remainingTimeInSeconds: Int) {
        activationView?.isResendSMSButtonEnabled(false)
        
        activationView?.progressView.progress = 0.0
        progress.completedUnitCount = 0
        start = 0
        progress.totalUnitCount = Int64(remainingTimeInSeconds)
        seconds = Double(remainingTimeInSeconds)

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
            if self.start <= Float(remainingTimeInSeconds) {
                // Progress view
                self.start += 0.01
                self.activationView?.progressView.setProgress(self.start/Float(remainingTimeInSeconds), animated: true)
                // Count down label
                self.seconds -= 0.01
                self.activationView?.updateCountDownLabel(time: self.seconds)
            } else {
                timer.invalidate()
                self.view.endEditing(true)
                self.activationView?.updateCountDownLabel(time: 0.00)
                self.activationView?.isResendSMSButtonEnabled(true)
                return
            }
        }
    }
    
    private func configureOTPView() {
        activationView?.otpStackView.delegate = self
    }
    
    // MARK: - UI interaction methods
    @objc func wrongNumberButtonTapped() {
        presenterActivation.wrongNumberButtonTapped()
    }
    
    @objc func resendSMSButtonTapped() {
        presenterActivation.resendSMSButtonTapped()
    }
}

// MARK: - PresenterActivationView methods
extension ActivationViewController: PresenterActivationView {
    func stopTimer() {
        timer?.invalidate()
    }
    
    func startTimer() {
        timer?.fire()
    }
    
    func didSetData(remainingTimeInSeconds: Int) {
        fireTimer(remainingTimeInSeconds)
        
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func tryAgain() {
        activationView?.otpStackView.resetOTP()
    }
}

// MARK: - ActivationViewController methods
extension ActivationViewController: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        if isValid, let otp = activationView?.otpStackView.getOTP() {
            view.endEditing(true)
            presenterActivation.OTPTapped(otp: otp)
        }
    }
}

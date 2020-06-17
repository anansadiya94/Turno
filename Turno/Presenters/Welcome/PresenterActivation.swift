//
//  PresenterActivation.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

protocol PresenterActivationView: class {
    func stopTimer()
    func startTimer()
    func didSetData(remainingTimeInSeconds: Int)
    func popViewController()
    func tryAgain()
}

class PresenterActivation: NSObject {
    
    // MARK: - Properties
    var view: ActivationViewController!
    var delegate: SelectButtonWelcome!
    var modelSignUpResponse: ModelSignUpResponse?
    let networkManager = NetworkManager()
    
    // MARK: - Public Interface
    init(view: ActivationViewController, delegate: SelectButtonWelcome, modelSignUpResponse: ModelSignUpResponse) {
        super.init()
        self.view = view
        self.delegate = delegate
        self.modelSignUpResponse = modelSignUpResponse
        self.didSetData()
    }
    
    private func didSetData() {
        if let modelSignUpResponse = modelSignUpResponse,
            let remainingTimeInSeconds = modelSignUpResponse.remainingTimeInSeconds {
            view?.didSetData(remainingTimeInSeconds: remainingTimeInSeconds)
        }
    }
    
    private func setPrefs(modelVerifyResponse: ModelVerifyResponse) {
        var user = Preferences.getPrefsUser()
        user?.secret = modelVerifyResponse.secret
        user?.userId = modelVerifyResponse.userId
        Preferences.setPrefsUser(user: user)
        Preferences.setPrefsAppState(value: .loggedIn)
    }
    
    // MARK: - UI interaction methods
    func wrongNumberButtonTapped() {
        view?.popViewController()
    }
    
    func resendSMSButtonTapped() {
        self.view.startWaiting()
        self.view.stopTimer()
        
        if let phoneNumber = Preferences.getPrefsUser()?.phoneNumber, let fullName = Preferences.getPrefsUser()?.name {
            let modelSignUp = ModelSignUp(phoneNumber: phoneNumber, fullName: fullName)
            networkManager.signUp(modelSignUp: modelSignUp) { (modelSignUpResponse, error) in
                if let error = error as? AppError {
                    self.view.stopWaiting()
                    self.view.showPopup(withTitle: LocalizedConstants.generic_error_title_key.localized,
                                        withText: error.errorDescription,
                                        withButton: LocalizedConstants.ok_key.localized.localized,
                                        completion: nil)
                    return
                }
                if let modelSignUpResponse = modelSignUpResponse {
                    self.view.stopWaiting()
                    self.view.tryAgain()
                    self.modelSignUpResponse = modelSignUpResponse
                    self.didSetData()
                    self.view.startTimer()
                }
            }
        }
    }

    func OTPTapped(otp: String) {
        self.view.startWaiting()
        
        if let phoneNumber = Preferences.getPrefsUser()?.phoneNumber {
            let modelVerify = ModelVerify(phoneNumber: phoneNumber, verificationCode: otp)
            networkManager.verify(modelVerify: modelVerify) { (modelVerifyResponse, error) in
                if let error = error as? AppError {
                    self.view.stopWaiting()
                    self.view.showPopup(withTitle: LocalizedConstants.generic_error_title_key.localized,
                                        withText: error.errorDescription,
                                        withButton: LocalizedConstants.ok_key.localized.localized,
                                        completion: { (_, _) in
                                            self.view?.tryAgain()
                    })
                    return
                }
                if let modelVerifyResponse = modelVerifyResponse {
                    self.setPrefs(modelVerifyResponse: modelVerifyResponse)
                    self.view.stopWaiting()
                    self.delegate.didOPTTapped()
                }
            }
        }
    }
}

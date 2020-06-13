//
//  PresenterActivation.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

protocol PresenterActivationView: class {
    func didSetData(remainingTimeInSeconds: Int)
    func popViewController()
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
        if let modelSignUpResponse = modelSignUpResponse {
            view?.didSetData(remainingTimeInSeconds: modelSignUpResponse.remainingTimeInSeconds)
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
    
    //TODO
    func resendSMSButtonTapped() {
        print("resendSMSButtonTapped")
    }
    
    //TODO
    func activateByCallButtonTapped() {
        print("activateByCallButtonTapped")
    }
    
    func OTPTapped(otp: String) {
        //TODO Call server and save token
        print("Code is: \(otp)")
        self.view.startWaiting()
        if let phoneNumber = Preferences.getPrefsUser()?.phoneNumber {
            let modelVerify = ModelVerify(phoneNumber: phoneNumber, verificationCode: otp)
            networkManager.verify(modelVerify: modelVerify) { (modelVerifyResponse, error) in
                if let error = error {
                    self.view.stopWaiting()
                    //TODO
                    self.view.showPopup(withTitle: "ERROR", withText: error.localizedDescription, withButton: "OK", completion: nil)
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

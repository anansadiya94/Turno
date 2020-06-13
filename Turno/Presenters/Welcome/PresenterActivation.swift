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
        Preferences.setPrefsAppState(value: .loggedIn)
        delegate.didOPTTapped()
    }
}

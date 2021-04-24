//
//  PresenterActivation.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Moya

protocol PresenterActivationView: PresenterParentView {
    func stopTimer()
    func startTimer()
    func didSetData(remainingTimeInSeconds: Int)
    func popViewController()
    func tryAgain()
}

class PresenterActivation: NSObject {
    
    // MARK: - Properties
    private weak var view: PresenterActivationView!
    private var networkManager: NetworkManagerProtocol
    private var delegate: SelectButtonWelcome?
    var modelSignUp: ModelSignUp?
    
    // MARK: - Public Interface
    init(view: PresenterActivationView, networkManager: NetworkManagerProtocol, delegate: SelectButtonWelcome, modelSignUp: ModelSignUp) {
        self.networkManager = networkManager
        super.init()
        self.view = view
        self.delegate = delegate
        self.modelSignUp = modelSignUp
        self.didSetData()
    }
    
    private func didSetData() {
        if let modelSignUp = modelSignUp,
            let remainingTimeInSeconds = modelSignUp.remainingTimeInSeconds {
            view?.didSetData(remainingTimeInSeconds: remainingTimeInSeconds)
        }
    }
    
    private func setPrefs(modelVerify: ModelVerify) {
        var user = Preferences.getPrefsUser()
        user?.secret = modelVerify.secret
        user?.userId = modelVerify.userId
        user?.businessId = modelVerify.businessId
        Preferences.setPrefsUser(user: user)
        Preferences.setPrefsAppState(value: .loggedIn)
        AppData.isBusiness = Preferences.isBusiness()
        
        // Set auth
        if let userId = user?.userId, let secret = user?.secret {
            let authorization = userId + ":" + secret
            let authorizationBase64 = Data(authorization.utf8).base64EncodedString()
            AppData.authorization = "Basic " + authorizationBase64
        }
    }
    
    // MARK: - UI interaction methods
    func wrongNumberButtonTapped() {
        view?.popViewController()
    }
    
    func resendSMSButtonTapped() {
        self.view?.startWaitingView()
        self.view.stopTimer()
        
        if let phoneNumber = Preferences.getPrefsUser()?.phoneNumber, let fullName = Preferences.getPrefsUser()?.name {
            let modelSignUpTask = ModelSignUpTask(phoneNumber: phoneNumber, fullName: fullName)
            networkManager.signUp(modelTask: modelSignUpTask) { (modelSignUp, error) in
                if error as? MoyaError != nil {
                    self.view?.stopWaitingView()
                    self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                             withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                             withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                             completion: nil)
                    return
                }
                if let error = error as? AppError {
                    self.view?.stopWaitingView()
                    self.view?.showPopupView(withTitle: error.title,
                                             withText: error.message,
                                             withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                             completion: nil)
                    return
                }
                if let modelSignUp = modelSignUp {
                    self.view?.stopWaitingView()
                    self.view.tryAgain()
                    self.modelSignUp = modelSignUp
                    self.didSetData()
                    self.view.startTimer()
                }
            }
        }
    }
    
    func OneTimeCodeFinished(with code: String) {
        self.view?.startWaitingView()
        
        if let phoneNumber = Preferences.getPrefsUser()?.phoneNumber {
            let modelVerifyTask = ModelVerifyTask(phoneNumber: phoneNumber, verificationCode: code)
            networkManager.verify(modelTask: modelVerifyTask) { (modelVerify, error) in
                if error as? MoyaError != nil {
                    self.view?.stopWaitingView()
                    self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                             withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                             withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                             completion: nil)
                    return
                }
                if let error = error as? AppError {
                    self.view?.stopWaitingView()
                    self.view?.showPopupView(withTitle: error.title,
                                             withText: error.message,
                                             withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                             completion: { (_, _) in
                                                self.view?.tryAgain()
                    })
                    return
                }
                if let modelVerify = modelVerify {
                    self.setPrefs(modelVerify: modelVerify)
                    if let userId = modelVerify.businessId {
                        let pushManager = PushNotificationManager(userId: userId,
                                                                  name: Preferences.getPrefsUser()?.name,
                                                                  networkManager: self.networkManager)
                        pushManager.registerForPushNotifications()
                    }
                    self.view?.stopWaitingView()
                    self.delegate?.didOPTTapped(isBusiness: (modelVerify.businessId != nil) ? true : false)
                }
            }
        }
    }
}

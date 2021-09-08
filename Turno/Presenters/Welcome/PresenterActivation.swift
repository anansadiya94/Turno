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
    private let networkManager: NetworkManagerProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    private weak var view: PresenterActivationView!
    private weak var delegate: SelectButtonWelcome?
    var modelSignUp: ModelSignUp?
    
    private struct Constants {
        static let screenName = "Activation Screen"
        static let wrongNumberAnalyticValue = LocalizedConstants.wrong_number_key.enLocalized
        static let resendSMSAnalyticValue = LocalizedConstants.resend_sms_key.enLocalized
    }
    
    // MARK: - Public Interface
    init(view: PresenterActivationView,
         networkManager: NetworkManagerProtocol,
         analyticsManager: AnalyticsManagerProtocol,
         delegate: SelectButtonWelcome,
         modelSignUp: ModelSignUp) {
        self.networkManager = networkManager
        self.analyticsManager = analyticsManager
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
        analyticsManager.track(eventKey: .buttonTapped, withProperties: [
            .buttonText: Constants.wrongNumberAnalyticValue,
            .screenName: Constants.screenName
        ])
        view?.popViewController()
    }
    
    func resendSMSButtonTapped() {
        analyticsManager.track(eventKey: .buttonTapped, withProperties: [
            .buttonText: Constants.resendSMSAnalyticValue,
            .screenName: Constants.screenName
        ])
        self.view?.startWaitingView()
        self.view.stopTimer()
        
        if let phoneNumber = Preferences.getPrefsUser()?.phoneNumber, let fullName = Preferences.getPrefsUser()?.name {
            let modelSignUpTask = ModelSignUpTask(phoneNumber: phoneNumber, fullName: fullName)
            networkManager.signUp(modelTask: modelSignUpTask) { [weak self] modelSignUp, error in
                guard let self = self else { return }
                if error as? MoyaError != nil {
                    self.analyticsManager.trackConnectionFailedAlert(screenName: Constants.screenName)
                    self.view?.stopWaitingView()
                    self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                             withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                             withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                             completion: nil)
                    return
                }
                if let error = error as? AppError {
                    self.analyticsManager.trackAlert(alertTitle: error.title,
                                                          alertMessage: error.message,
                                                          screenName: Constants.screenName)
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
                    self.trackSignedInUser()
                    if let userId = modelVerify.businessId {
                        let pushManager = PushNotificationManager(userId: userId,
                                                                  name: Preferences.getPrefsUser()?.name,
                                                                  networkManager: self.networkManager,
                                                                  analyticsManager: self.analyticsManager)
                        pushManager.registerForPushNotifications()
                    }
                    self.view?.stopWaitingView()
                    self.delegate?.didOPTTapped(isBusiness: (modelVerify.businessId != nil) ? true : false)
                }
            }
        }
    }
}

private extension PresenterActivation {
    func trackSignedInUser() {
        guard let userId = Preferences.getPrefsUser()?.userId else {
            // track error!
            return
        }
        analyticsManager.identify(distinctId: userId)
        analyticsManager.peopleSet(properties: [
            AnalyticsPeoplePropertyKeys.name: Preferences.getPrefsUser()?.name,
            AnalyticsPeoplePropertyKeys.phoneNumber: Preferences.getPrefsUser()?.phoneNumber,
            AnalyticsPeoplePropertyKeys.businessId: Preferences.getPrefsUser()?.businessId
        ])
        analyticsManager.track(eventKey: .registeredSuccessfully, withProperties: nil)
    }
}

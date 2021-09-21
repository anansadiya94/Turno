//
//  PresenterBlockedUsers.swift
//  Turno
//
//  Created by Anan Sadiya on 30/12/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterBlockedUsersView: PresenterParentView {
    func didSetData(model: BlockedUsersListDescriptive)
    func showEmptyMessage(title: String, message: String)
    func removeEmptyMessage()
    func addTapped(title: String, message: String)
}

class PresenterBlockedUsers {
    
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    private weak var view: PresenterBlockedUsersView?
    private weak var delegate: SelectButtonBusiness?
    var modelList = [ModelBlockedUser]()
    
    // MARK: - init Methods
    init(view: PresenterBlockedUsersView,
         networkManager: NetworkManagerProtocol,
         analyticsManager: AnalyticsManagerProtocol,
         delegate: SelectButtonBusiness) {
        self.view = view
        self.networkManager = networkManager
        self.analyticsManager = analyticsManager
        self.delegate = delegate
        self.fetchData()
    }
    
    private struct Constants {
        static let screenName = "Blocked Users Screen"
        static let plusAnalyticValue = "Plus"
        static let unblockAnalyticValue = "Unblock"
        static let noAnalyticValue = LocalizedConstants.no_key.enLocalized
        static let yesAnalyticValue = LocalizedConstants.yes_key.enLocalized
    }
    
    // MARK: - Private methods
    private func notifyView() {
        trackScreen(totalOfBlockedUsers: modelList.count)
        let blockedUsersListDescriptive = BlockedUsersListDescriptive(modelList: modelList)
        self.view?.didSetData(model: blockedUsersListDescriptive)
    }
    
    private func unblockConfirmed(userId: String?) {
        if let userId = userId {
            let modelBlockUser = ModelBlockUser(userId: userId)
            networkManager.unblockUser(modelBlockUser: modelBlockUser) { [weak self] _, error in
                guard let self = self else { return }
                if error as? MoyaError != nil {
                    self.analyticsManager.trackConnectionFailedAlert(screenName: Constants.screenName)
                    self.view?.stopWaitingView()
                    self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                             withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                             withButton: LocalizedConstants.ok_key.localized.localized,
                                             button2: nil,
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
                                             withButton: LocalizedConstants.ok_key.localized.localized,
                                             button2: nil,
                                             completion: nil)
                    return
                }
                self.fetchData()
            }
        }
    }
    
    // MARK: - Public Interface
    func trackScreen(totalOfBlockedUsers: Int) {
        analyticsManager.track(eventKey: .blockerUsersScreenSeen, withProperties: [
            .totalOfBlockedUsers: String(describing: totalOfBlockedUsers)
        ])
    }
    
    func fetchData() {
        self.view?.startWaitingView()
        self.view?.removeEmptyMessage()
        networkManager.getMyBlockedList { [weak self] modelList, error in
            guard let self = self else { return }
            if error as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
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
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            self.view?.stopWaitingView()
            if let modelList = modelList, !modelList.isEmpty {
                self.modelList = modelList
            } else {
                self.modelList = []
                self.view?.showEmptyMessage(title: LocalizedConstants.no_blocked_users_title_key.localized,
                                            message: LocalizedConstants.no_blocked_users_message_key.localized)
            }
            self.notifyView()
        }
    }
    
    func addTapped() {
        analyticsManager.track(eventKey: .buttonTapped, withProperties: [
            .buttonText: Constants.plusAnalyticValue,
            .screenName: Constants.screenName
        ])
        self.view?.addTapped(title: LocalizedConstants.user_to_block_title_key.localized, message: "")
    }
    
    func unblockTapped(userId: String?) {
        analyticsManager.track(eventKey: .buttonTapped, withProperties: [
            .buttonText: Constants.unblockAnalyticValue,
            .screenName: Constants.screenName
        ])
        self.view?.showPopupView(withTitle: LocalizedConstants.unblock_user_title_key.localized,
                                 withText: LocalizedConstants.unblock_user_message_key.localized,
                                 withButton: LocalizedConstants.no_key.localized,
                                 button2: LocalizedConstants.yes_key.localized,
                                 completion: { [weak self] no, yes in
                                    guard let self = self else { return }
                                    if no == true {
                                        self.analyticsManager.track(eventKey: .alertActionTapped, withProperties: [
                                            .actionText: Constants.noAnalyticValue,
                                            .screenName: Constants.screenName
                                        ])
                                    }
                                    if yes == true {
                                        self.analyticsManager.track(eventKey: .alertActionTapped, withProperties: [
                                            .actionText: Constants.yesAnalyticValue,
                                            .screenName: Constants.screenName
                                        ])
                                        self.unblockConfirmed(userId: userId)
                                    }
                                 })
    }
    
    func blockUser(phoneNumber: String) {
        self.view?.startWaitingView()
        self.view?.removeEmptyMessage()
        let modelBlockUser = ModelBlockUser(phoneNumber: phoneNumber)
        networkManager.blockUser(modelBlockUser: modelBlockUser) { [weak self] _, error in
            guard let self = self else { return }
            if error as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
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
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            self.fetchData()
        }
    }
}

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
    private weak var view: PresenterBlockedUsersView?
    var delegate: SelectButtonBusiness!
    var modelList = [ModelBlockedUser]()
    let networkManager = NetworkManager()
    
    // MARK: - init Methods
    init(view: PresenterBlockedUsersView, delegate: SelectButtonBusiness) {
        self.view = view
        self.delegate = delegate
        self.fetchData()
    }
    
    // MARK: - Private methods
    private func notifyView() {
        let blockedUsersListDescriptive = BlockedUsersListDescriptive(modelList: modelList)
        self.view?.didSetData(model: blockedUsersListDescriptive)
    }
    
    private func unblockConfirmed(userId: String?) {
        if let userId = userId {
            let modelBlockUser = ModelBlockUser(userId: userId)
            networkManager.unblockUser(modelBlockUser: modelBlockUser
            ) { _, error in
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
                self.fetchData()
            }
        }
    }
    
    // MARK: - Public Interface
    func fetchData() {
        self.view?.startWaitingView()
        self.view?.removeEmptyMessage()
        networkManager.getMyBlockedList { (modelList, error) in
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
            self.view?.stopWaitingView()
            if let modelList = modelList, !modelList.isEmpty {
                self.modelList = modelList
            } else {
                self.modelList = []
                // TODO: Translate
                self.view?.showEmptyMessage(title: "No blocked users",
                                            message: "block users to see them here.")
            }
            self.notifyView()
        }
    }
    
    func addTapped() {
        self.view?.addTapped(title: "User to block", message: "")
    }
    
    func unblockTapped(userId: String?) {
        // TODO: Translate
        self.view?.showPopupView(withTitle: "Are you sure you want to unblock this user?",
                                 withText: "Are you sure you want to unblock this user?",
                                 withButton: "No", button2: "Yes",
                                 completion: { (_, yes) in
                                    if yes == true {
                                        self.unblockConfirmed(userId: userId)
                                    }
        })
    }
    
    func blockUser(phoneNumber: String) {
        self.view?.startWaitingView()
        self.view?.removeEmptyMessage()
        let modelBlockUser = ModelBlockUser(phoneNumber: phoneNumber)
        networkManager.blockUser(modelBlockUser: modelBlockUser) { _, error in
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
            self.fetchData()
        }
    }
}

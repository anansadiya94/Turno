//
//  PresenterHome.swift
//  Turno
//
//  Created by Anan Sadiya on 24/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterUserHomeView: PresenterParentView {
    func didSetData(model: GenericListDescriptive)
    func showEmptyMessage(title: String, message: String)
    func removeEmptyMessage()
}

class PresenterUserHome {
    
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    private weak var view: PresenterUserHomeView?
    private weak var delegate: SelectButtonEntity?
    var modelList = [ModelBusiness]()
    
    private struct Constants {
        static let screenName = "Home User Screen"
        static let heartAnalyticValue = "Heart"
        static let refreshAnalyticValue = "Refresh"
    }
    
    // MARK: - init Methods
    init(view: PresenterUserHomeView,
         networkManager: NetworkManagerProtocol,
         analyticsManager: AnalyticsManagerProtocol,
         delegate: SelectButtonEntity) {
        self.view = view
        self.networkManager = networkManager
        self.analyticsManager = analyticsManager
        self.delegate = delegate
        self.fetchData()
    }
    
    // MARK: - Private methods
    private func notifyView() {
        let genericListDescriptive = GenericListDescriptive(modelList: self.modelList)
        view?.didSetData(model: genericListDescriptive)
    }
    
    private func showGenericEmptyMessage() {
        view?.showEmptyMessage(title: LocalizedConstants.generic_error_title_key.localized,
                               message: LocalizedConstants.home_error_message_key.localized)
    }
    
    // MARK: - Public Interface
    func trackScreen() {
        analyticsManager.track(eventKey: .homeUserScreenSeen, withProperties: nil)
    }
    
    func fetchData() {
        view?.startWaitingView()
        view?.removeEmptyMessage()
        let modelBusinessTask = ModelBusinessTask(query: "")
        networkManager.getBusinesses(modelTask: modelBusinessTask) { [weak self] modelList, error in
            guard let self = self else { return }
            if error as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil) { _, _ in
                    self.showGenericEmptyMessage()
                }
                return
            }
            if let error = error as? AppError {
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil) { _, _ in
                    self.showGenericEmptyMessage()
                }
                return
            }
            if let modelList = modelList {
                self.view?.stopWaitingView()
                self.modelList = modelList
                self.notifyView()
            }
        }
    }
    
    func cellTapped(model: ModelBusiness) {
        analyticsManager.track(eventKey: .businessTapped, withProperties: [
            .businessIdentifier: model.identifier ?? "",
            .businessName: model.name ?? "",
            .screenName: Constants.screenName
        ])
        delegate?.didSelectEntity(model: model)
    }
    
    func isFavoriteTapped(entityIdentifier: String) {
        if let index = modelList.firstIndex(where: { $0.identifier == entityIdentifier }),
           let identifier = modelList[index].identifier,
           let isFavorite = modelList[index].isFavorite {
            analyticsManager.track(eventKey: .buttonTapped, withProperties: [
                .buttonText: Constants.heartAnalyticValue,
                .businessName: identifier,
                .isFavorite: isFavorite ? "false" : "true",
                .screenName: Constants.screenName
            ])
            let modelFavoritesTask = ModelFavoritesTask(businessId: identifier)
            if isFavorite {
                networkManager.removeFromFavorites(modelTask: modelFavoritesTask) { [weak self] _, error in
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
                }
                modelList[index].isFavoriteTapped()
            } else {
                networkManager.addToFavorites(modelTask: modelFavoritesTask) { [weak self] _, error in
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
                }
                modelList[index].isFavoriteTapped()
            }
        }
    }
}

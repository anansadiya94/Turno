//
//  PresenterFavorites.swift
//  Turno
//
//  Created by Anan Sadiya on 28/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterFavoritesView: PresenterParentView {
    func didSetData(model: GenericListDescriptive)
    func showEmptyMessage(title: String, message: String)
    func removeEmptyMessage()
}

class PresenterFavorites {
    
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    private weak var view: PresenterFavoritesView?
    private weak var delegate: SelectButtonEntity?
    var modelList = [ModelBusiness]()
    
    // MARK: - init Methods
    init(view: PresenterFavoritesView,
         networkManager: NetworkManagerProtocol,
         analyticsManager: AnalyticsManagerProtocol,
         delegate: SelectButtonEntity) {
        self.view = view
        self.networkManager = networkManager
        self.analyticsManager = analyticsManager
        self.delegate = delegate
        self.fetchData()
    }
    
    private struct Constants {
        static let screenName = "Favorites Screen"
        static let heartAnalyticValue = "Heart"
    }
    
    // MARK: - Private methods
    private func notifyView() {
        trackScreen(totalBusinesses: modelList.count)
        let genericListDescriptive = GenericListDescriptive(modelList: modelList)
        self.view?.didSetData(model: genericListDescriptive)
    }
    
    // MARK: - Public Interface
    func trackScreen(totalBusinesses: Int) {
        analyticsManager.track(eventKey: .favoritesScreenSeen, withProperties: [
            .totalBusinesses: String(describing: totalBusinesses)
        ])
    }
    
    func fetchData() {
        self.view?.startWaitingView()
        self.view?.removeEmptyMessage()
        networkManager.getFavorites { [weak self] modelList, error in
            guard let self = self else { return }
            if error as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized,
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
                                         withButton: LocalizedConstants.ok_key.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            self.view?.stopWaitingView()
            if let modelList = modelList, !modelList.isEmpty {
                self.modelList = modelList
            } else {
                self.modelList = []                
                self.view?.showEmptyMessage(title: LocalizedConstants.no_favorites_error_title_key.localized,
                                            message: LocalizedConstants.no_favorites_error_message_key.localized)
            }
            self.notifyView()
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
        if let model = modelList.filter({$0.identifier == entityIdentifier}).first,
           let identifier = model.identifier,
           let isFavorite = model.isFavorite {
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
                                                 withButton: LocalizedConstants.ok_key.localized, button2: nil,
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
                                                 withButton: LocalizedConstants.ok_key.localized, button2: nil,
                                                 completion: nil)
                        return
                    }
                    self.fetchData()
                }
            }    
        }
    }
}

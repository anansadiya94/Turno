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
    private weak var view: PresenterFavoritesView?
    var delegate: SelectButtonEntity!
    var modelList = [ModelBusiness]()
    let networkManager = NetworkManager()
    
    // MARK: - init Methods
    init(view: PresenterFavoritesView, delegate: SelectButtonEntity) {
        self.view = view
        self.fetchData()
        self.delegate = delegate
    }
    
    // MARK: - Private methods
    private func notifyView() {
        let genericListDescriptive = GenericListDescriptive(modelList: self.modelList)
        self.view?.didSetData(model: genericListDescriptive)
    }
    
    // MARK: - Public Interface
    func fetchData() {
        self.view?.startWaitingView()
        self.view?.removeEmptyMessage()
        networkManager.getFavorites { (modelList, error) in
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
                self.view?.showEmptyMessage(title: LocalizedConstants.no_favorites_error_title_key.localized,
                                            message: LocalizedConstants.no_favorites_error_message_key.localized)
            }
            self.notifyView()
        }
    }
    
    func isFavoriteTapped(entityIdentifier: String) {
        if let model = modelList.filter({$0.identifier == entityIdentifier}).first,
            let identifier = model.identifier,
            let isFavorite = model.isFavorite {
            let modelFavoritesTask = ModelFavoritesTask(businessId: identifier)
            if isFavorite {
                networkManager.removeFromFavorites(modelTask: modelFavoritesTask) { _, error in
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
    }
}

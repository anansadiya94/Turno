//
//  PresenterHome.swift
//  Turno
//
//  Created by Anan Sadiya on 24/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit
import Moya

protocol PresenterHomeView: PresenterParentView {
    func didSetData(model: GenericListDescriptive)
}

class PresenterHome {
    
    // MARK: - Properties
    private weak var view: PresenterHomeView?
    var delegate: SelectButtonEntity!
    var modelList = [ModelBusiness]()
    let networkManager = NetworkManager()
    
    // MARK: - init Methods
    init(view: PresenterHomeView, delegate: SelectButtonEntity) {
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
        let modelBusinessTask = ModelBusinessTask(query: "")
        networkManager.getBusinesses(modelBusinessTask: modelBusinessTask) { (modelList, error) in
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
            if let modelList = modelList {
                self.view?.stopWaitingView()
                self.modelList = modelList
                self.notifyView()
            }
        }
    }

    func isFavoriteTapped(entityIdentifier: String) {
        if let index = modelList.firstIndex(where: { $0.identifier == entityIdentifier }),
            let identifier = modelList[index].identifier,
            let isFavorite = modelList[index].isFavorite {
            let modelFavoritesTask = ModelFavoritesTask(businessId: identifier)
            if isFavorite {
                networkManager.removeFromFavorites(modelFavoritesTask: modelFavoritesTask) { _, error in
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
                }
                modelList[index].isFavoriteTapped()
                
            } else {
                networkManager.addToFavorites(modelFavoritesTask: modelFavoritesTask) { _, error in
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
                }
                modelList[index].isFavoriteTapped()
            }
        }
    }
}

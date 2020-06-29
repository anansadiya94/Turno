//
//  NetworkManager.swift
//  Turno
//
//  Created by Anan Sadiya on 13/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import Moya

protocol Networkable {
    var provider: MoyaProvider<APIRouter> { get }

    func signUp(modelSignUpTask: ModelSignUpTask, completion: @escaping (ModelSignUp?, Error?) -> Void)
    func verify(modelVerifyTask: ModelVerifyTask, completion: @escaping (ModelVerify?, Error?) -> Void)
    func getBusinesses(modelBusinessTask: ModelBusinessTask, completion: @escaping ([ModelBusiness]?, Error?) -> Void)
    func getFavorites(completion: @escaping ([ModelBusiness]?, Error?) -> Void)
    func addToFavorites(modelFavoritesTask: ModelFavoritesTask, completion: @escaping (Bool?, Error?) -> Void)
    func removeFromFavorites(modelFavoritesTask: ModelFavoritesTask, completion: @escaping (Bool?, Error?) -> Void)
}

class NetworkManager: Networkable {

    let provider = MoyaProvider<APIRouter>()
    
    func signUp(modelSignUpTask: ModelSignUpTask, completion: @escaping (ModelSignUp?, Error?) -> Void) {
        provider.request(.signUp(modelSignUpTask: modelSignUpTask)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let modelSignUp = try decoder.decode(ModelSignUp.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelSignUp, nil)
                    default:
                        completion(nil, AppError(title: modelSignUp.title ?? "", message: modelSignUp.message ?? ""))
                    }
                } catch let error {
                    completion(nil, error)
                }
            }
        }
    }
    
    func verify(modelVerifyTask: ModelVerifyTask, completion: @escaping (ModelVerify?, Error?) -> Void) {
        provider.request(.verify(modelVerifyTask: modelVerifyTask)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let modelVerify = try decoder.decode(ModelVerify.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelVerify, nil)
                    default:
                        completion(nil, AppError(title: modelVerify.title ?? "", message: modelVerify.message ?? ""))
                    }
                } catch let error {
                    completion(nil, error)
                }
            }
        }
    }
    
    func getBusinesses(modelBusinessTask: ModelBusinessTask, completion: @escaping ([ModelBusiness]?, Error?) -> Void) {
        provider.request(.getBusinesses(modelBusinessTask: modelBusinessTask)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let modelList = try decoder.decode([ModelBusiness].self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelList, nil)
                    default:
                        break
                    }
                } catch let error {
                    completion(nil, error)
                }
            }
        }
    }
    
    func getFavorites(completion: @escaping ([ModelBusiness]?, Error?) -> Void) {
        provider.request(.getFavorites) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let modelList = try decoder.decode([ModelBusiness].self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelList, nil)
                    default:
                        break
                    }
                } catch let error {
                    completion(nil, error)
                }
            }
        }
    }
    
    func addToFavorites(modelFavoritesTask: ModelFavoritesTask, completion: @escaping (Bool?, Error?) -> Void) {
        provider.request(.addToFavorites(modelFavoritesTask: modelFavoritesTask)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                switch value.statusCode {
                case 200:
                    completion(true, nil)
                default:
                    break
                }
            }
        }
    }
    
    func removeFromFavorites(modelFavoritesTask: ModelFavoritesTask, completion: @escaping (Bool?, Error?) -> Void) {
        provider.request(.removeToFavorites(modelFavoritesTask: modelFavoritesTask)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                switch value.statusCode {
                case 200:
                    completion(true, nil)
                default:
                    break
                }
            }
        }
    }
}

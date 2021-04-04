//
//  NetworkManager.swift
//  Turno
//
//  Created by Anan Sadiya on 13/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import Moya

protocol NetworkManagerProtocol {
    var provider: MoyaProvider<APIRouter> { get }
    
    func signUp(modelTask: ModelSignUpTask, completion: @escaping (ModelSignUp?, Error?) -> Void)
    func verify(modelTask: ModelVerifyTask, completion: @escaping (ModelVerify?, Error?) -> Void)
    func getBusinesses(modelTask: ModelBusinessTask, completion: @escaping ([ModelBusiness]?, Error?) -> Void)
    func getFavorites(completion: @escaping ([ModelBusiness]?, Error?) -> Void)
    func addToFavorites(modelTask: ModelFavoritesTask, completion: @escaping (Bool?, Error?) -> Void)
    func removeFromFavorites(modelTask: ModelFavoritesTask, completion: @escaping (Bool?, Error?) -> Void)
    func cancelTurn(modelTask: ModelCancelTurnTask, completion: @escaping (Bool?, Error?) -> Void)
    func getAvailableTimes(modelTask: ModelCheckTurnsAvailabilityTask, completion: @escaping (ModelCheckTurnsAvailability?, Error?) -> Void)
    func book(modelTask: ModelBookTask, completion: @escaping (Turn?, Error?) -> Void)
    func bookByBusiness(modelTask: ModelBookByBusinessTask, completion: @escaping (Turn?, Error?) -> Void)
    func getMyBusiness(completion: @escaping (ModelBusiness?, Error?) -> Void)
    func getMyBookings(modelTask: ModelMyBookingTask, completion: @escaping (ModelMyBookings?, Error?) -> Void)
    func getMyBlockedList(completion: @escaping ([ModelBlockedUser]?, Error?) -> Void)
    func unblockUser(modelBlockUser: ModelBlockUser, completion: @escaping (Bool?, Error?) -> Void)
    func blockUser(modelBlockUser: ModelBlockUser, completion: @escaping (Bool?, Error?) -> Void)
    func registerFCMToken(modelFcmTokenTask: ModelFcmTokenTask, completion: @escaping (Bool?, Error?) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    let provider = MoyaProvider<APIRouter>()
    
    func signUp(modelTask: ModelSignUpTask, completion: @escaping (ModelSignUp?, Error?) -> Void) {
        provider.request(.signUp(modelSignUpTask: modelTask)) { result in
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
    
    func verify(modelTask: ModelVerifyTask, completion: @escaping (ModelVerify?, Error?) -> Void) {
        provider.request(.verify(modelVerifyTask: modelTask)) { result in
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
    
    func getBusinesses(modelTask: ModelBusinessTask, completion: @escaping ([ModelBusiness]?, Error?) -> Void) {
        provider.request(.getBusinesses(modelBusinessTask: modelTask)) { result in
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
    
    func addToFavorites(modelTask: ModelFavoritesTask, completion: @escaping (Bool?, Error?) -> Void) {
        provider.request(.addToFavorites(modelFavoritesTask: modelTask)) { result in
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
    
    func removeFromFavorites(modelTask: ModelFavoritesTask, completion: @escaping (Bool?, Error?) -> Void) {
        provider.request(.removeToFavorites(modelFavoritesTask: modelTask)) { result in
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
    
    func cancelTurn(modelTask: ModelCancelTurnTask, completion: @escaping (Bool?, Error?) -> Void) {
        provider.request(.cancelTurn(modelCancelTurnTask: modelTask)) { result in
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
    
    func getAvailableTimes(modelTask: ModelCheckTurnsAvailabilityTask, completion: @escaping (ModelCheckTurnsAvailability?, Error?) -> Void) {
        provider.request(.getAvailableTimes(modelCheckTurnsAvailabilityTask: modelTask)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let modelList = try decoder.decode(ModelCheckTurnsAvailability.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelList, nil)
                    default:
                        completion(nil, AppError(title: modelList.title ?? "", message: modelList.message ?? ""))
                    }
                } catch let error {
                    completion(nil, error)
                }
            }
        }
    }
    
    func book(modelTask: ModelBookTask, completion: @escaping (Turn?, Error?) -> Void) {
        provider.request(.book(modelBookTask: modelTask)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let turn = try decoder.decode(Turn.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(turn, nil)
                    default:
                        completion(nil, AppError(title: turn.title ?? "", message: turn.message ?? ""))
                    }
                } catch let error {
                    completion(nil, error)
                }
            }
        }
    }
    
    func bookByBusiness(modelTask: ModelBookByBusinessTask, completion: @escaping (Turn?, Error?) -> Void) {
        provider.request(.bookByBusiness(modelBookByBusinessTask: modelTask)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let turn = try decoder.decode(Turn.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(turn, nil)
                    default:
                        completion(nil, AppError(title: turn.title ?? "", message: turn.message ?? ""))
                    }
                } catch let error {
                    completion(nil, error)
                }
            }
        }
    }
    
    func getMyBusiness(completion: @escaping (ModelBusiness?, Error?) -> Void) {
        provider.request(.getMyBusiness) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let modelBusiness = try decoder.decode(ModelBusiness.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelBusiness, nil)
                    default:
                        completion(nil, AppError(title: modelBusiness.title ?? "", message: modelBusiness.message ?? ""))
                    }
                } catch let error {
                    completion(nil, error)
                }
            }
        }
    }
    
    func getMyBookings(modelTask: ModelMyBookingTask, completion: @escaping (ModelMyBookings?, Error?) -> Void) {
        provider.request(.getMyBookings(modelMyBookingTask: modelTask)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let modelMyBookings = try decoder.decode(ModelMyBookings.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelMyBookings, nil)
                    default:
                        completion(nil, AppError(title: modelMyBookings.title ?? "", message: modelMyBookings.message ?? ""))
                    }
                } catch let error {
                    completion(nil, error)
                }
            }
        }
    }
    
    func getMyBlockedList(completion: @escaping ([ModelBlockedUser]?, Error?) -> Void) {
        provider.request(.getMyBlockedList) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let modelList = try decoder.decode([ModelBlockedUser].self, from: value.data)
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
    
    func unblockUser(modelBlockUser: ModelBlockUser, completion: @escaping (Bool?, Error?) -> Void) {
        provider.request(.unblockUser(modelBlockUser: modelBlockUser)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                switch value.statusCode {
                case 200:
                    completion(true, nil)
                default:
                    completion(false, nil)
                }
            }
        }
    }
    
    func blockUser(modelBlockUser: ModelBlockUser, completion: @escaping (Bool?, Error?) -> Void) {
        provider.request(.blockUser(modelBlockUser: modelBlockUser)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                switch value.statusCode {
                case 200:
                    completion(true, nil)
                default:
                    completion(false, nil)
                }
            }
        }
    }
    
    func registerFCMToken(modelFcmTokenTask: ModelFcmTokenTask, completion: @escaping (Bool?, Error?) -> Void) {
        provider.request(.registerFCMToken(modelFcmTokenTask: modelFcmTokenTask)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                switch value.statusCode {
                case 200:
                    completion(true, nil)
                default:
                    completion(false, nil)
                }
            }
        }
    }
}

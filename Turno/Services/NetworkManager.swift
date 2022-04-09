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
    func shouldForceUpdate(modelForceUpdateTask: ModelForceUpdateTask, completion: @escaping (Bool?, Error?) -> Void)
}

class NetworkManager {
    private enum DateError: String, Error {
        case invalidDate
    }
    
    let provider = MoyaProvider<APIRouter>()
    
    private let decoder = JSONDecoder()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    init() {
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            if let date = self.dateFormatter.date(from: dateStr) {
                return date
            }
            throw DateError.invalidDate
        })
    }
}

extension NetworkManager: NetworkManagerProtocol {
    func signUp(modelTask: ModelSignUpTask, completion: @escaping (ModelSignUp?, Error?) -> Void) {
        provider.request(.signUp(modelSignUpTask: modelTask)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                do {
                    let modelSignUp = try self.decoder.decode(ModelSignUp.self, from: value.data)
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
        provider.request(.verify(modelVerifyTask: modelTask)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                do {
                    let modelVerify = try self.decoder.decode(ModelVerify.self, from: value.data)
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
        provider.request(.getBusinesses(modelBusinessTask: modelTask)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                do {
                    let modelList = try self.decoder.decode([ModelBusiness].self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelList, nil)
                    default:
                        completion(nil, AppError(title: LocalizedConstants.generic_error_title_key.localized,
                                                 message: LocalizedConstants.generic_error_message_key.localized))
                    }
                } catch let error {
                    // LOG ERROR!
                    print(error)
                    let modelMessage = try? self.decoder.decode(ApiError.self, from: value.data)
                    let title = modelMessage?.title ?? LocalizedConstants.generic_error_title_key.localized
                    let message = modelMessage?.message ?? LocalizedConstants.generic_error_message_key.localized
                    completion(nil, AppError(title: title, message: message))
                }
            }
        }
    }
    
    func getFavorites(completion: @escaping ([ModelBusiness]?, Error?) -> Void) {
        provider.request(.getFavorites) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                do {
                    let modelList = try self.decoder.decode([ModelBusiness].self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelList, nil)
                    default:
                        // LOG ERROR!
                        completion(nil, AppError(title: LocalizedConstants.generic_error_title_key.localized,
                                                 message: LocalizedConstants.generic_error_message_key.localized))
                    }
                } catch let error {
                    // LOG ERROR!
                    print(error)
                    let modelMessage = try? self.decoder.decode(ApiError.self, from: value.data)
                    let title = modelMessage?.title ?? LocalizedConstants.generic_error_title_key.localized
                    let message = modelMessage?.message ?? LocalizedConstants.generic_error_message_key.localized
                    completion(nil, AppError(title: title, message: message))
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
                    // LOG ERROR!
                    completion(nil, AppError(title: LocalizedConstants.generic_error_title_key.localized,
                                             message: LocalizedConstants.generic_error_message_key.localized))
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
                    completion(nil, AppError(title: LocalizedConstants.generic_error_title_key.localized,
                                             message: LocalizedConstants.generic_error_message_key.localized))
                }
            }
        }
    }
    
    func cancelTurn(modelTask: ModelCancelTurnTask, completion: @escaping (Bool?, Error?) -> Void) {
        provider.request(.cancelTurn(modelCancelTurnTask: modelTask)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                switch value.statusCode {
                case 200:
                    completion(true, nil)
                default:
                    do {
                        let apiError = try self.decoder.decode(ApiError.self, from: value.data)
                        completion(false, AppError(title: apiError.title ?? "", message: apiError.message ?? ""))
                    } catch let error {
                        // LOG ERROR!
                        print(error)
                        completion(nil, AppError(title: LocalizedConstants.generic_error_title_key.localized,
                                                 message: LocalizedConstants.generic_error_message_key.localized))
                    }
                }
            }
        }
    }
    
    func getAvailableTimes(modelTask: ModelCheckTurnsAvailabilityTask, completion: @escaping (ModelCheckTurnsAvailability?, Error?) -> Void) {
        provider.request(.getAvailableTimes(modelCheckTurnsAvailabilityTask: modelTask)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                do {
                    let modelList = try self.decoder.decode(ModelCheckTurnsAvailability.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelList, nil)
                    default:
                        completion(nil, AppError(title: modelList.title ?? "",
                                                 message: modelList.message ?? "",
                                                 code: value.statusCode))
                    }
                } catch let error {
                    // LOG ERROR!
                    print(error)
                    completion(nil, AppError(title: LocalizedConstants.generic_error_title_key.localized,
                                             message: LocalizedConstants.generic_error_message_key.localized))
                }
            }
        }
    }
    
    func book(modelTask: ModelBookTask, completion: @escaping (Turn?, Error?) -> Void) {
        provider.request(.book(modelBookTask: modelTask)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                do {
                    let turn = try self.decoder.decode(Turn.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(turn, nil)
                    default:
                        completion(nil, AppError(title: turn.title ?? "", message: turn.message ?? ""))
                    }
                } catch let error {
                    // LOG ERROR!
                    print(error)
                    completion(nil, AppError(title: LocalizedConstants.generic_error_title_key.localized,
                                             message: LocalizedConstants.generic_error_message_key.localized))
                }
            }
        }
    }
    
    func bookByBusiness(modelTask: ModelBookByBusinessTask, completion: @escaping (Turn?, Error?) -> Void) {
        provider.request(.bookByBusiness(modelBookByBusinessTask: modelTask)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                do {
                    let turn = try self.decoder.decode(Turn.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(turn, nil)
                    default:
                        completion(nil, AppError(title: turn.title ?? "", message: turn.message ?? ""))
                    }
                } catch let error {
                    // LOG ERROR!
                    print(error)
                    completion(nil, AppError(title: LocalizedConstants.generic_error_title_key.localized,
                                             message: LocalizedConstants.generic_error_message_key.localized))
                }
            }
        }
    }
    
    func getMyBusiness(completion: @escaping (ModelBusiness?, Error?) -> Void) {
        provider.request(.getMyBusiness) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                do {
                    let modelBusiness = try self.decoder.decode(ModelBusiness.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelBusiness, nil)
                    default:
                        completion(nil, AppError(title: modelBusiness.title ?? "", message: modelBusiness.message ?? ""))
                    }
                } catch let error {
                    // LOG ERROR!
                    print(error)
                    completion(nil, AppError(title: LocalizedConstants.generic_error_title_key.localized,
                                             message: LocalizedConstants.generic_error_message_key.localized))
                }
            }
        }
    }
    
    func getMyBookings(modelTask: ModelMyBookingTask, completion: @escaping (ModelMyBookings?, Error?) -> Void) {
        provider.request(.getMyBookings(modelMyBookingTask: modelTask)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                do {
                    let modelMyBookings = try self.decoder.decode(ModelMyBookings.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelMyBookings, nil)
                    default:
                        completion(nil, AppError(title: modelMyBookings.title ?? "", message: modelMyBookings.message ?? ""))
                    }
                } catch let error {
                    // LOG ERROR!
                    print(error)
                    completion(nil, AppError(title: LocalizedConstants.generic_error_title_key.localized,
                                             message: LocalizedConstants.generic_error_message_key.localized))
                }
            }
        }
    }
    
    func getMyBlockedList(completion: @escaping ([ModelBlockedUser]?, Error?) -> Void) {
        provider.request(.getMyBlockedList) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                do {
                    let modelList = try self.decoder.decode([ModelBlockedUser].self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelList, nil)
                    default:
                        // LOG ERROR!
                        completion(nil, AppError(title: LocalizedConstants.generic_error_title_key.localized,
                                                 message: LocalizedConstants.generic_error_message_key.localized))
                    }
                } catch let error {
                    // LOG ERROR!
                    print(error)
                    let modelMessage = try? self.decoder.decode(ApiError.self, from: value.data)
                    let title = modelMessage?.title ?? LocalizedConstants.generic_error_title_key.localized
                    let message = modelMessage?.message ?? LocalizedConstants.generic_error_message_key.localized
                    completion(nil, AppError(title: title, message: message))
                }
            }
        }
    }
    
    func unblockUser(modelBlockUser: ModelBlockUser, completion: @escaping (Bool?, Error?) -> Void) {
        provider.request(.unblockUser(modelBlockUser: modelBlockUser)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                switch value.statusCode {
                case 200:
                    completion(true, nil)
                default:
                    do {
                        let apiError = try self.decoder.decode(ApiError.self, from: value.data)
                        completion(false, AppError(title: apiError.title ?? "", message: apiError.message ?? ""))
                    } catch let error {
                        // LOG ERROR!
                        print(error)
                        completion(nil, AppError(title: LocalizedConstants.generic_error_title_key.localized,
                                                 message: LocalizedConstants.generic_error_message_key.localized))
                    }
                }
            }
        }
    }
    
    func blockUser(modelBlockUser: ModelBlockUser, completion: @escaping (Bool?, Error?) -> Void) {
        provider.request(.blockUser(modelBlockUser: modelBlockUser)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                switch value.statusCode {
                case 200:
                    completion(true, nil)
                default:
                    do {
                        let apiError = try self.decoder.decode(ApiError.self, from: value.data)
                        completion(false, AppError(title: apiError.title ?? "", message: apiError.message ?? ""))
                    } catch let error {
                        // LOG ERROR!
                        print(error)
                        completion(nil, AppError(title: LocalizedConstants.generic_error_title_key.localized,
                                                 message: LocalizedConstants.generic_error_message_key.localized))
                    }
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
    
    func shouldForceUpdate(modelForceUpdateTask: ModelForceUpdateTask, completion: @escaping (Bool?, Error?) -> Void) {
        provider.request(.shouldForceUpdate(modelForceUpdateTask: modelForceUpdateTask)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                do {
                    let modelForceUpdate = try self.decoder.decode(ModelForceUpdate.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelForceUpdate.shouldForceUpdate, nil)
                    default:
                        completion(false, nil)
                    }
                } catch let error {
                    completion(nil, error)
                }
            }
        }
    }
}

//
//  APIRouter.swift
//  Turno
//
//  Created by Anan Sadiya on 13/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import Moya

enum APIRouter {
    
    // MARK: - Sign Up
    case signUp(modelSignUpTask: ModelSignUpTask)
    case verify(modelVerifyTask: ModelVerifyTask)
    
    // MARK: - Buisenesses
    case getBusinesses(modelBusinessTask: ModelBusinessTask)
    case getFavorites
    case addToFavorites(modelFavoritesTask: ModelFavoritesTask)
    case removeToFavorites(modelFavoritesTask: ModelFavoritesTask)
    case cancelTurn(modelCancelTurnTask: ModelCancelTurnTask)
    case getAvailableTimes(modelCheckTurnsAvailabilityTask: ModelCheckTurnsAvailabilityTask)
    case book(modelBookTask: ModelBookTask)
    case bookByBusiness(modelBookByBusinessTask: ModelBookByBusinessTask)
    case getMyBusiness
    case getMyBookings(modelMyBookingTask: ModelMyBookingTask)
    case getMyBlockedList
    case unblockUser(modelBlockUser: ModelBlockUser)
    case blockUser(modelBlockUser: ModelBlockUser)
    case registerFCMToken(modelFcmTokenTask: ModelFcmTokenTask)
}

extension APIRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: kBaseURL)!
    }
    
    var path: String {
        switch self {
        case .signUp: return kSignUp
        case .verify: return kVerify
        case .getBusinesses: return kGetBusinesses
        case .getFavorites: return kGetFavorites
        case .addToFavorites: return kAddToFavorites
        case .removeToFavorites: return kRemoveFromFavorites
        case .cancelTurn: return kCancelTurn
        case .getAvailableTimes: return kGetAvailableTimes
        case .book: return kBook
        case .bookByBusiness: return kBookByBusiness
        case .getMyBusiness: return kGetMyBusiness
        case .getMyBookings: return kGetMyBookings
        case .getMyBlockedList: return kGetMyBlockedList
        case .unblockUser: return kUnblockUser
        case .blockUser: return kBlockUser
        case .registerFCMToken: return kRegisterFCMToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .verify, .getBusinesses, .getFavorites, .addToFavorites, .removeToFavorites,
             .cancelTurn, .getAvailableTimes, .book, .bookByBusiness, .getMyBusiness, .getMyBookings, .getMyBlockedList,
             .unblockUser, .blockUser, .registerFCMToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signUp(let modelSignUpTask):
            return .requestJSONEncodable(modelSignUpTask)
        case .verify(let modelVerify):
            return .requestJSONEncodable(modelVerify)
        case .getBusinesses(let modelBusinessTask):
            return .requestJSONEncodable(modelBusinessTask)
        case .getFavorites, .getMyBusiness, .getMyBlockedList:
            return .requestPlain
        case .addToFavorites(let modelFavoritesTask), .removeToFavorites(let modelFavoritesTask):
            return .requestJSONEncodable(modelFavoritesTask)
        case .cancelTurn(let modelCancelTurnTask):
            return .requestJSONEncodable(modelCancelTurnTask)
        case .getAvailableTimes(let modelCheckTurnsAvailabilityTask):
            return .requestJSONEncodable(modelCheckTurnsAvailabilityTask)
        case .book(let modelBookTask):
            return .requestJSONEncodable(modelBookTask)
        case .bookByBusiness(let modelBookByBusinessTask):
            return .requestJSONEncodable(modelBookByBusinessTask)
        case .unblockUser(let modelBlockUser), .blockUser(let modelBlockUser):
            return .requestJSONEncodable(modelBlockUser)
        case .getMyBookings(let modelMyBookingTask):
            return .requestJSONEncodable(modelMyBookingTask)
        case .registerFCMToken(let modelFcmTokenTask):
            return .requestJSONEncodable(modelFcmTokenTask)
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        var headers: [String: String] = [:]
        headers = ["Content-type": "application/json; charset=UTF-8",
                   "Accept-Language": Locale.current.languageCode ?? "en"]
        
        switch self {
        case .getBusinesses, .getFavorites, .addToFavorites, .removeToFavorites, .cancelTurn,
             .getAvailableTimes, .book, .bookByBusiness, .getMyBusiness, .getMyBookings,
             .getMyBlockedList, .unblockUser, .blockUser, .registerFCMToken:
            headers["Authorization"] = AppData.authorization
        default:
            break
        }
        return headers
    }
}

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
        }
    }
  
    var method: Moya.Method {
        switch self {
        case .signUp, .verify, .getBusinesses, .getFavorites:
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
        case .getFavorites:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        var headers: [String: String] = [:]
        headers = ["Content-type": "application/json; charset=UTF-8"]
        
        switch self {
        case .getBusinesses, .getFavorites:
            headers = ["Authorization": Preferences.getAuthorization()]
        default:
            break
        }
        return headers
    }
}

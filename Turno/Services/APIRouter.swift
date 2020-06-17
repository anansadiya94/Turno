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
    case signUp(modelSignUp: ModelSignUp)
    case verify(modelVerify: ModelVerify)
}

extension APIRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: kBaseURL)!
    }
    
    var path: String {
        switch self {
        case .signUp: return kSignUp
        case .verify: return kVerify
        }
    }
  
    var method: Moya.Method {
        switch self {
        case .signUp, .verify:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signUp(let modelSignUp):
            return .requestJSONEncodable(modelSignUp)
        case .verify(let modelVerify):
            return .requestJSONEncodable(modelVerify)
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json; charset=UTF-8"]
    }
}
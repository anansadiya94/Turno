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

    func signUp(modelSignUp: ModelSignUp, completion: @escaping (ModelSignUpResponse?, Error?) -> Void)
    func verify(modelVerify: ModelVerify, completion: @escaping (ModelVerifyResponse?, Error?) -> Void)
}

class NetworkManager: Networkable {
    
    let provider = MoyaProvider<APIRouter>()
    
    func signUp(modelSignUp: ModelSignUp, completion: @escaping (ModelSignUpResponse?, Error?) -> Void) {
        provider.request(.signUp(modelSignUp: modelSignUp)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let modelSignUpResponse = try decoder.decode(ModelSignUpResponse.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelSignUpResponse, nil)
                    default:
                        completion(nil, AppError(title: modelSignUpResponse.title ?? "", message: modelSignUpResponse.message ?? ""))
                    }
                } catch let error {
                    completion(nil, error)
                }
            }
        }
    }
    
    func verify(modelVerify: ModelVerify, completion: @escaping (ModelVerifyResponse?, Error?) -> Void) {
        provider.request(.verify(modelVerify: modelVerify)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let value):
                let decoder = JSONDecoder()
                do {
                    let modelVerifyResponse = try decoder.decode(ModelVerifyResponse.self, from: value.data)
                    switch value.statusCode {
                    case 200:
                        completion(modelVerifyResponse, nil)
                    default:
                        completion(nil, AppError(title: modelVerifyResponse.title ?? "", message: modelVerifyResponse.message ?? ""))
                    }
                } catch let error {
                    completion(nil, error)
                }
            }
        }
    }
}

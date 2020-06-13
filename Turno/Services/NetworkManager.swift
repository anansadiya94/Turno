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
                    completion(modelSignUpResponse, nil)
                } catch let error {
                    completion(nil, error)
                }
            }
        }
    }
}

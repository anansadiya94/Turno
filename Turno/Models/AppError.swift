//
//  AppError.swift
//  Turno
//
//  Created by Anan Sadiya on 15/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

enum AppError: Error {
    case message(String)
    case generic
    case malformedData
    
    public var errorDescription: String? {
        switch self {
        case .message(let message): return message
        case .generic: return "generic_error_text".localized
        default: return ""
        }
    }
}

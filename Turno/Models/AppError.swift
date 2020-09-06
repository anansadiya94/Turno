//
//  AppError.swift
//  Turno
//
//  Created by Anan Sadiya on 15/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct AppError: Error {
    let title: String?
    let message: String?
    let code: Int?
}

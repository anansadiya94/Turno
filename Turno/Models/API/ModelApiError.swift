//
//  ModelApiError.swift
//  Turno
//
//  Created by Anan Sadiya on 29/12/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

protocol ModelApiError {
    var title: String? { get }
    var message: String? { get }
}

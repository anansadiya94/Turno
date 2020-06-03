//
//  App.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class App {
    
    enum State {
        case unregistered
        case loggedIn //TODO: ModelUser
        case sessionExpired //TODO: ModelUser
    }
  
    static var state = State.unregistered
}

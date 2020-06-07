//
//  PresenterActivation.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

protocol PresenterActivationView: class {
    func popViewController()
}

class PresenterActivation: NSObject {
    
    // MARK: - Properties
    var view: ActivationViewController!
    var delegate: SelectButtonWelcome!
    
    // MARK: - Public Interface
    init(view: ActivationViewController, delegate: SelectButtonWelcome) {
        super.init()
        self.view = view
        self.delegate = delegate
    }
    
    // MARK: - UI interaction methods
    func wrongNumberButtonTapped() {
        view?.popViewController()
    }
    
    //TODO
    func resendSMSButtonTapped() {
        print("resendSMSButtonTapped")
    }
    
    //TODO
    func activateByCallButtonTapped() {
        print("activateByCallButtonTapped")
    }
    
    func finishButtonTapped() {
        delegate.didSelectFinishButton()
    }
}

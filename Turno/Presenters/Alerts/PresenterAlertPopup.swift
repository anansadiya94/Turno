//
//  PresenterAlertPopup.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

protocol PresenterAlertPopupView: class {
    func popViewController()
}

class PresenterAlertPopup: NSObject {
    
    // MARK: - Properties
    private weak var view: AlertPopupViewController?
    var delegate: SelectButtonWelcome!
    var modelAlertPopup = ModelAlertPopup()
    
    // MARK: - init Methods
    init(view: AlertPopupViewController, delegate: SelectButtonWelcome, modelAlertPopup: ModelAlertPopup) {
        super.init()
        self.view = view
        self.delegate = delegate
        self.modelAlertPopup = modelAlertPopup
    }

    // MARK: - Public Interface
    func button1AlertTapped() {
        view?.popViewController()
        NotificationCenter.default.post(name: Alert.alertButton1Tapped, object: nil)
    }
    
    func button2AlertTapped() {
        view?.popViewController()
        NotificationCenter.default.post(name: Alert.alertButton2Tapped, object: nil)
    }
}

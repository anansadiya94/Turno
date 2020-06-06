//
//  AlertPopupViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 06/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class AlertPopupViewController: UIViewController {
    
    // MARK: - Properties
    var presenterAlertPopup: PresenterAlertPopup!
    var alertPopupView = AlertPopupView()

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setAlertPopupView()
        addTargets()
        setAlertData(modelAlertPopup: presenterAlertPopup.modelAlertPopup)
    }
    
    // MARK: - Private methods
    private func setAlertPopupView() {
        alertPopupView = AlertPopupView(frame: view.frame)
        self.view = alertPopupView
    }
    
    private func addTargets() {
        alertPopupView.alertButton1.addTarget(self, action: #selector(button1AlertTapped), for: .touchUpInside)
        alertPopupView.alertButton2.addTarget(self, action: #selector(button2AlertTapped), for: .touchUpInside)
    }
    
    private func setAlertData(modelAlertPopup: ModelAlertPopup) {
        alertPopupView.setAlertDataView(modelAlertPopup: modelAlertPopup)
    }
    
    // MARK: - UI interaction methods
    @objc func button1AlertTapped() {
        presenterAlertPopup.button1AlertTapped()
    }
    
    @objc func button2AlertTapped() {
        presenterAlertPopup.button2AlertTapped()
    }
}

// MARK: - PresenterAlertPopupView methods
extension AlertPopupViewController: PresenterAlertPopupView {
    func popViewController() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

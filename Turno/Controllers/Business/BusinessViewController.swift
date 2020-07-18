//
//  BusinessViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 18/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class BusinessViewController: ParentViewController {
    
    // MARK: - Properties
    var presenterBusiness: PresenterBusiness!
    @UseAutoLayout var businessView = BusinessView()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setBusinessViewConstraints()
    }
    
    // MARK: - Private methods
    private func setBusinessViewConstraints() {
        self.view.addSubview(businessView)
        NSLayoutConstraint.activate([
            businessView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            businessView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            businessView.leftAnchor.constraint(equalTo: view.leftAnchor),
            businessView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

// MARK: - PresenterBusinessView methods
extension BusinessViewController: PresenterBusinessView {
    func didSetData(model: ModelBusiness) {
        DispatchQueue.main.async {
            self.navigationItem.title = model.name
            self.businessView.setImage(image: model.image)
        }
    }
    
    func startWaitingView() {
        startWaiting()
    }
    
    func stopWaitingView() {
        stopWaiting()
    }
    
    func showPopupView(withTitle title: String?, withText text: String?, withButton button: String?, button2: String?, completion: ((Bool?, Bool?) -> Void)?) {
        showPopup(withTitle: title, withText: text, withButton: button, button2: button2, completion: completion)
    }
}

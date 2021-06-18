//
//  PresenterOnboarding.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

protocol PresenterOnboardingView: AnyObject {
    func setPages(num: Int)
    func didSetData()
    func nextCell()
}

class PresenterOnboarding: NSObject {
    
    // MARK: - Properties
    private weak var view: PresenterOnboardingView?
    private weak var delegate: SelectButtonOnboarding?
    var modelOnboardingList = [ModelOnboarding]()
    
    // MARK: - init Methods
    init(view: PresenterOnboardingView, onBoardingList: [ModelOnboarding]) {
        super.init()
        self.view = view
        self.modelOnboardingList = onBoardingList
        self.notifyView()
    }
    
    init(view: PresenterOnboardingView, delegate: SelectButtonOnboarding) {
        super.init()
        self.view = view
        self.delegate = delegate
        self.fetchData()
    }
    
    // MARK: - Private methods
    private func setOnBoardingCompletedObject() {
        AppData.onBoardingCompleted = true
    }
    
    private func notifyView() {
        self.view?.setPages(num: modelOnboardingList.count)
        self.view?.didSetData()
    }
    
    private func fetchData() {
        ServiceOnboarding.fetchData(callback: { (modelList) in
            self.modelOnboardingList = modelList
            self.notifyView()
        }, withNetwork: false)
    }
    
    // MARK: - UI interaction methods
    func buttonCellTappedAction(amILast: Bool) {
        if amILast {
            AppData.onBoardingCompleted = true
            delegate?.didSelectOnboardingButton()
        } else {
            self.view?.nextCell()
        }
    }
}

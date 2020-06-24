//
//  PresenterHome.swift
//  Turno
//
//  Created by Anan Sadiya on 24/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

protocol PresenterHomeView: class {
    func didSetData(model: HomeListDescriptive)
}

class PresenterHome {
    
    // MARK: - Properties
    private weak var view: PresenterHomeView?
    var delegate: SelectButtonHome!
    var modelList = [ModelBusiness]()
    
    // MARK: - init Methods
    init(view: PresenterHomeView, delegate: SelectButtonHome) {
        self.view = view
        self.fetchData()
        self.delegate = delegate
    }
    
    // MARK: - Private methods
    private func fetchData() {
        modelList = [ModelBusiness(identifier: "1", image: "https://maletti.it/media/cache/regular/uploads/images/casehistory/gallery/5db15a1bd1e21.jpg", name: "Barber1"),
                     ModelBusiness(identifier: "2", image: "https://recursos.bps.com.es/files/810/16.jpg", name: "Barber2"),
                     ModelBusiness(identifier: "2", image: "https://recursos.bps.com.es/files/810/16.jpg", name: "Barber2"),
                     ModelBusiness(identifier: "2", image: "https://recursos.bps.com.es/files/810/16.jpg", name: "Barber2"),
                     ModelBusiness(identifier: "2", image: "https://recursos.bps.com.es/files/810/16.jpg", name: "Barber2"),
                     ModelBusiness(identifier: "2", image: "https://recursos.bps.com.es/files/810/16.jpg", name: "Barber2")]
        notifyView()
    }
    
    private func notifyView() {
        let homeListDescriptive = HomeListDescriptive(modelList: self.modelList)
        self.view?.didSetData(model: homeListDescriptive)
    }
}

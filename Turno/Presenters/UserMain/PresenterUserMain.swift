//
//  PresenterMain.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class PresenterUserMain: NSObject {
    
    // MARK: - Properties
    let analyticsManager: AnalyticsManagerProtocol
    var view: UserMainViewController!
    
    // MARK: - Public Interface
    init(view: UserMainViewController,
         analyticsManager: AnalyticsManagerProtocol) {
        self.analyticsManager = analyticsManager
        super.init()
        self.view = view
    }
    
    func tabBarDidSelect(previousTabName: String, currentTabName: String) {
        analyticsManager.track(eventKey: .bottomNavigationTabTap, withProperties: [
            .previousTabName: previousTabName,
            .currentTabName: currentTabName
        ])
    }
}

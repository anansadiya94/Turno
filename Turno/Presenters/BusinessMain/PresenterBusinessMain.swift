//
//  PresenterBusinessMain.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

class PresenterBusinessMain: NSObject {
    
    // MARK: - Properties
    let analyticsManager: AnalyticsManagerProtocol
    var view: BusinessMainViewController!
    
    // MARK: - Public Interface
    init(view: BusinessMainViewController,
         analyticsManager: AnalyticsManagerProtocol) {
        self.analyticsManager = analyticsManager
        super.init()
        self.view = view
    }
    
    func tabBarDidSelect(currentTabName: String, tappedTabName: String) {
        analyticsManager.track(eventKey: .bottomNavigationTabTap, withProperties: [
            .currentTabName: currentTabName,
            .tappedTabName: tappedTabName
        ])
    }
}

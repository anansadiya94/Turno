//
//  Notification+Name.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct OnBoarding {
    static let onBoardingButtonCellTapped = Notification.Name(kNotificaitonButtonOnboardingCellTapped)
}

struct GenericEntity {
    static let isFavoriteTapped = Notification.Name(kNotificaitonGenericEntityCellIsFavoriteTapped)
    static let cellTapped = Notification.Name(kNotificaitonGenericEntityCellTapped)
}

struct Appointments {
    static let cancelTapped = Notification.Name(kNotificaitonGenericEntityCellIsFavoriteTapped)
    static let callNowTapped = Notification.Name(kNotificaitonGenericEntityCellIsFavoriteTapped)
}

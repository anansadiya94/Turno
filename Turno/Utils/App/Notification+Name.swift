//
//  Notification+Name.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation

struct OnBoarding {
    static let onBoardingButtonCellTapped = Notification.Name(kNotificationButtonOnboardingCellTapped)
}

struct GenericEntity {
    static let isFavoriteTapped = Notification.Name(kNotificationGenericEntityCellIsFavoriteTapped)
    static let cellTapped = Notification.Name(kNotificationGenericEntityCellTapped)
}

struct Appointments {
    static let cancelTapped = Notification.Name(kNotificationCancelTapped)
    static let callNowTapped = Notification.Name(kNotificationCallNowTapped)
    static let appointmentConfirmed = Notification.Name(kNotificationAppointmentConfirmed)
}

struct Business {
    static let modifyModel = Notification.Name(kNotificationBusinessModifyModel)
}

struct BlockedUsers {
    static let unblockTapped = Notification.Name(kNotificationUnblockTapped)
}

struct Settings {
    static let changeToUser = Notification.Name(kNotificationChangeToUserTapped)
    static let changeToBusiness = Notification.Name(kNotificationChangeToBusinessTapped)
}

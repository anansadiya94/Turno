//
//  AnalyticsManager.swift
//  Turno
//
//  Created by Anan Sadiya on 09/08/2021.
//  Copyright © 2021 Anan Sadiya. All rights reserved.
//

import Foundation
import Mixpanel

enum AnalyticsKeys: String {
    // Common
    case appMovedToBackground = "App Moved to Background"
    case buttonTapped = "Button Tapped"
    case errorDisplayed = "Error Displayed"
    case registeredSuccessfully = "Registered Successfully"
    case topNavigationTabTap = "Top Navigation - Tab Tap"
    case bottomNavigationTabTap = "Bottom Navigation - Tab Tap"
    case turnTapped = "Turn Tapped"
    case alertDisplayed = "Alert Displayed"
    case alertActionTapped = "Alert Action Tapped"
    case dayTapped = "Day Tapped"
    case hourTapped = "Hour Tapped"
    case settingsTapped = "Settings Tapped"
    case businessTapped = "Business Tapped"
    case informationTapped = "Information Tapped"
    
    // Screens seen
    case onboardingScreenSeen = "Onboarding Seen"
    case welcomeScreenSeen = "Welcome Seen"
    case installScreenSeen = "Install Seen"
    case activationScreenSeen = "Activation Seen"
    case homeBusinessScreenSeen = "Home Business Seen"
    case homeUserScreenSeen = "Home User Seen"
    case addAppointmentScreenSeen = "Add Appointment Seen"
    case checkAvailabilityScreenSeen = "Check Availability Seen"
    case confirmationScreenSeen = "Confirmation Seen"
    case settingsScreenSeen = "Settings Seen"
    case blockerUsersScreenSeen = "Blocked Users Seen"
    case businessScreenSeen = "Business Seen"
    case myTurnsScreenSeen = "My Turns Seen"
    case favoritesScreenSeen = "Favorites Seen"
}

enum AnalyticsEventPropertyKeys: String {
    case buttonText = "Button Text"
    case actionText = "Action Text"
    case screenName = "Screen Name"
    case name = "Name"
    case phoneNumber = "Phone Number"
    case alertTitle = "Alert Title"
    case alertMessage = "Alert Message"
    case previousTabName = "Previous Tab Name"
    case currentTabName = "Current Tab Name"
    case turnIdentifier = "Turn Identifier"
    case totalOfServices = "Total Of Services"
    case totalOfServicesTime = "Total Of Services Time"
    case selectedDate = "Selected Date"
    case startTime = "Start Time"
    case endTime = "End Time"
    case settingsRow = "Settings Row"
    case totalOfBlockedUsers = "Total Of Blocked Users"
    case businessIdentifier = "Business Identifier"
    case businessName = "Business Name"
    case isFavorite = "Is Favorite"
    case informationRowType = "Information Row Type"
    case informationRowText = "Information Row Text"
    case totalTurns = "Total Turns"
    case totalBusinesses = "Total Businesses"
}

enum AnalyticsPeoplePropertyKeys: String {
    case pushNotificationOptIn = "Push Notification Opt-In"
    case firebaseToken = "Firebase token"
    case name = "$name"
    case phoneNumber = "Phone Number"
    case userId = "User Id"
    case businessId = "Business Id"
    case deviceLanguage = "Device Language"
}

struct CommonAnalyticsValues {
    static let connectionFailedTitle = LocalizedConstants.connection_failed_error_title_key.enLocalized
    static let connectionFailedMessage = LocalizedConstants.connection_failed_error_message_key.enLocalized
}

protocol AnalyticsManagerProtocol {
    func track(eventKey: AnalyticsKeys, withProperties properties: [AnalyticsEventPropertyKeys: String]?)
    func trackAlert(alertTitle: String?, alertMessage: String?, screenName: String)
    func trackConnectionFailedAlert(screenName: String)
    func identify(distinctId: String)
    func peopleSet(properties: [AnalyticsPeoplePropertyKeys: MixpanelType])
}

class AnalyticsManager: AnalyticsManagerProtocol {
    init() {
        Mixpanel.initialize(token: "74984b10074f7d370086f5a157e539d9")
    }
    
    func track(eventKey: AnalyticsKeys, withProperties properties: [AnalyticsEventPropertyKeys: String]?) {
        let reducedProperties = properties?.reduce(into: [:]) { result, dictionary in
            result[dictionary.key.rawValue] = dictionary.value
        }
        Mixpanel.mainInstance().track(event: eventKey.rawValue, properties: reducedProperties)
    }
    
    func trackAlert(alertTitle: String?, alertMessage: String?, screenName: String) {
        track(eventKey: .alertDisplayed, withProperties: [
            .alertTitle: alertTitle ?? "",
            .alertMessage: alertMessage ?? "",
            .screenName: screenName
        ])
    }
    
    func trackConnectionFailedAlert(screenName: String) {
        track(eventKey: .alertDisplayed, withProperties: [
            .alertTitle: LocalizedConstants.connection_failed_error_title_key.enLocalized,
            .alertMessage: LocalizedConstants.connection_failed_error_message_key.enLocalized,
            .screenName: screenName
        ])
    }
    
    func identify(distinctId: String) {
        Mixpanel.mainInstance().identify(distinctId: distinctId)
    }
    
    func peopleSet(properties: [AnalyticsPeoplePropertyKeys: MixpanelType]) {
        let reducedProperties = properties.reduce(into: [:]) { result, dictionary in
            result[dictionary.key.rawValue] = dictionary.value
        }
        Mixpanel.mainInstance().people.set(properties: reducedProperties)
    }
}

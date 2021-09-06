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
    case appMovedToBackground  = "App Moved to Background"
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
    case currentTabName = "Current Tab Name"
    case tappedTabName = "Tapped Tab Name"
    case turnIdentifier = "Turn Identifier"
    case totalOfServices = "Total Of Services"
    case totalOfServicesTime = "Total Of Services Time"
    case selectedDay = "Selected Day"
    case selectedHour = "Selected Hour"
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

protocol AnalyticsManagerProtocol {
    func track(eventKey: AnalyticsKeys, withProperties properties: [String: String]?)
    func identify(distinctId: String)
    func peopleSet(properties: Properties)
}

class AnalyticsManager: AnalyticsManagerProtocol {
    
    init() {
        Mixpanel.initialize(token: "74984b10074f7d370086f5a157e539d9")
    }
    
    func track(eventKey: AnalyticsKeys, withProperties properties: [String: String]?) {
        Mixpanel.mainInstance().track(event: eventKey.rawValue, properties: properties)
    }
    
    func identify(distinctId: String) {
        Mixpanel.mainInstance().identify(distinctId: distinctId)
    }
    
    func peopleSet(properties: Properties) {
        Mixpanel.mainInstance().people.set(properties: properties)
    }
}

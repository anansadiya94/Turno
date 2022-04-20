//
//  PresenterBusinessHome.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterBusinessHomeView: AnyObject {
    func didSetData(modelBusiness: ModelBusiness, modelMyBookings: ModelMyBookings)
    func startWaitingView()
    func stopWaitingView()
    func showPopupView(withTitle title: String?, withText text: String?, withButton button: String?, button2: String?, completion: ((Bool?, Bool?) -> Void)?)
    func appointmentConfirmed(bookedTurn: Turn)
}

class PresenterBusinessHome {
    
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    private let forceUpdateManager: ForceUpdateManagerProtocol
    private weak var view: PresenterBusinessHomeView?
    private weak var delegate: SelectButtonBusiness?
    var modelBusiness: ModelBusiness?
    var modelMyBookings: ModelMyBookings?
    var isFetching: Bool = false
    var lastStatusCheck: Date?
    
    private struct Constants {
        static let screenName = "Home Business Screen"
        static let plusAnalyticValue = "Plus"
        static let refreshAnalyticValue = "Refresh"
    }
    
    // MARK: - init Methods
    init(view: PresenterBusinessHomeView,
         networkManager: NetworkManagerProtocol,
         analyticsManager: AnalyticsManagerProtocol,
         forceUpdateManager: ForceUpdateManagerProtocol,
         delegate: SelectButtonBusiness) {
        self.view = view
        self.networkManager = networkManager
        self.analyticsManager = analyticsManager
        self.forceUpdateManager = forceUpdateManager
        self.delegate = delegate
        self.fetchData()
    }
    
    private func notifyView() {
        guard let modelBusiness = modelBusiness,
              let modelMyBookings = modelMyBookings else {
            self.view?.showPopupView(withTitle: LocalizedConstants.generic_error_title_key.localized,
                                     withText: LocalizedConstants.generic_error_message_key.localized,
                                     withButton: LocalizedConstants.ok_key.localized,
                                     button2: nil,
                                     completion: nil)
            return
        }
        view?.didSetData(modelBusiness: modelBusiness, modelMyBookings: modelMyBookings)
    }
    
    func trackScreen() {
        analyticsManager.track(eventKey: .homeBusinessScreenSeen, withProperties: nil)
    }
    
    func fetchData() {
        // Preventing multiple calls
        guard isFetching == false else {
            return
        }
        self.isFetching = true
        
        let dispatchGroup = DispatchGroup()
        var fetchError: Error?
        
        self.view?.startWaitingView()
        // FIRST CALL
        dispatchGroup.enter()
        networkManager.getMyBusiness { [weak self] modelBusiness, error in
            if let modelBusiness = modelBusiness {
                self?.modelBusiness = modelBusiness
            } else {
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        // SECOND CALL
        dispatchGroup.enter()
        let modelTask = ModelMyBookingTask(lastStatusCheck: "")
        networkManager.getMyBookings(modelTask: modelTask) { [weak self] modelMyBookings, error in
            if let modelMyBookings = modelMyBookings {
                self?.modelMyBookings = modelMyBookings
                self?.lastStatusCheck = Date()
            } else {
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.isFetching = false
            self.view?.stopWaitingView()
            if fetchError as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: Constants.screenName)
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            if let error = fetchError as? AppError {
                self.analyticsManager.trackAlert(alertTitle: error.title,
                                                 alertMessage: error.message,
                                                 screenName: Constants.screenName)
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            self.notifyView()
        }
    }
    
    func fetchMyBookings() {
        // Preventing multiple calls
        guard isFetching == false else {
            return
        }
        self.isFetching = true
        
        let modelTask = ModelMyBookingTask(lastStatusCheck: lastStatusCheck?.toString())
        networkManager.getMyBookings(modelTask: modelTask) { [weak self] modelMyBookings, error in
            guard let self = self else { return }
            self.isFetching = false
            if error as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            if let error = error as? AppError {
                self.analyticsManager.trackAlert(alertTitle: error.title,
                                                 alertMessage: error.message,
                                                 screenName: Constants.screenName)
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            if let modelMyBookings = modelMyBookings {
                self.modelMyBookings = modelMyBookings
                self.lastStatusCheck = Date()
            }
            self.notifyView()
        }
    }
    
    // MARK: - UI interaction methods
    func addAppointmentTapped() {
        analyticsManager.track(eventKey: .buttonTapped, withProperties: [
            .buttonText: Constants.plusAnalyticValue,
            .screenName: Constants.screenName
        ])
        delegate?.addAppointmentTapped(modelBusiness: modelBusiness)
    }
    
    func refreshTapped() {
        analyticsManager.track(eventKey: .buttonTapped, withProperties: [
            .buttonText: Constants.refreshAnalyticValue,
            .screenName: Constants.screenName
        ])
        fetchMyBookings()
    }
    
    func showAppointmentTapped(turn: Turn) {
        analyticsManager.track(eventKey: .turnTapped, withProperties: [
            .turnIdentifier: turn.identifier ?? "",
            .screenName: Constants.screenName
        ])
        delegate?.showAppointmentTapped(turn: turn)
    }
    
    func appointmentConfirmed(bookedTurn: Turn) {
        view?.appointmentConfirmed(bookedTurn: bookedTurn)
    }
    
    func shouldForceUpdate(completion: @escaping (Bool) -> Void) {
        forceUpdateManager.shouldForceUpdate(completion: completion)
    }
}

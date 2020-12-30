//
//  PresenterBusinessHome.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterBusinessHomeView: class {
    func didSetData(modelBusiness: ModelBusiness, modelMyBookings: ModelMyBookings)
    func startWaitingView()
    func stopWaitingView()
    func showPopupView(withTitle title: String?, withText text: String?, withButton button: String?, button2: String?, completion: ((Bool?, Bool?) -> Void)?)
    func appointmentConfirmed(bookedTurn: Turn)
}

class PresenterBusinessHome {
    
    // MARK: - Properties
    private weak var view: PresenterBusinessHomeView?
    var delegate: SelectButtonBusiness!
    let networkManager = NetworkManager()
    var modelBusiness: ModelBusiness?
    var modelMyBookings: ModelMyBookings?
    
    // MARK: - init Methods
    init(view: PresenterBusinessHomeView, delegate: SelectButtonBusiness) {
        self.view = view
        self.delegate = delegate
        self.fetchData()
    }

    private func notifyView() {
        guard let modelBusiness = modelBusiness,
              let modelMyBookings = modelMyBookings else {
            //TODO
            return
        }
        view?.didSetData(modelBusiness: modelBusiness, modelMyBookings: modelMyBookings)
    }
    
    func fetchData() {
        let dispatchGroup = DispatchGroup()
        var fetchError: Error?
        
        self.view?.startWaitingView()
        // FIRST CALL
        dispatchGroup.enter()
        networkManager.getMyBusiness { (modelBusiness, error) in
            if let modelBusiness = modelBusiness {
                self.modelBusiness = modelBusiness
            } else {
                fetchError = error
            }
            dispatchGroup.leave()
        }
           
        // SECOND CALL
        dispatchGroup.enter()
        networkManager.getMyBookings { (modelMyBookings, error) in
            if let modelMyBookings = modelMyBookings {
                self.modelMyBookings = modelMyBookings
            } else {
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.view?.stopWaitingView()
            if fetchError as? MoyaError != nil {
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                         completion: nil)
                dispatchGroup.leave()
                return
            }
            if let error = fetchError as? AppError {
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                         completion: nil)
                dispatchGroup.leave()
                return
            }
            self.notifyView()
        }
    }
    
    func addAppointmentTapped() {
        delegate.addAppointmentTapped(modelBusiness: modelBusiness)
    }
    
    func showAppointmentTapped(turn: Turn) {
        delegate.showAppointmentTapped(turn: turn)
    }
    
    func appointmentConfirmed(bookedTurn: Turn) {
        view?.appointmentConfirmed(bookedTurn: bookedTurn)
    }
}
//
//  PresenterAddAppointment.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Moya

protocol PresenterAddAppointmentView: PresenterParentView {
    func didSetData(modelBusiness: ModelBusiness)
    func showNameTextFieldLabel(type: TextFieldErrorType)
    func showPhoneNumberTextFieldLabel(type: TextFieldErrorType)
    func showAlert(customer: Customer)
    func modifyModel(identifier: String, count: Int)
}

class PresenterAddAppointment {
    
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let analyticsManager: AnalyticsManagerProtocol
    private weak var view: PresenterAddAppointmentView?
    private weak var delegate: SelectButtonBusiness?
    var modelBusiness: ModelBusiness?
    var customer: Customer?
    
    private struct Constants {
        static let screenName = "Add Appointment Screen"
        static let checkAvailabilityAnalyticValue = LocalizedConstants.check_availability_key.enLocalized
        static let noAvailableDatesTitleAnalyticValue = LocalizedConstants.no_available_dates_title_key.enLocalized
        static let noAvailableDatesMessageAnalyticValue = LocalizedConstants.no_available_dates_message_key.enLocalized
    }
    
    // MARK: - init Methods
    init(view: PresenterAddAppointmentView,
         networkManager: NetworkManagerProtocol,
         analyticsManager: AnalyticsManagerProtocol,
         delegate: SelectButtonBusiness,
         modelBusiness: ModelBusiness?) {
        self.view = view
        self.networkManager = networkManager
        self.analyticsManager = analyticsManager
        self.delegate = delegate
        self.modelBusiness = modelBusiness
        self.notifyView()
    }
    
    // MARK: - Private methods
    private func notifyView() {
        guard let modelBusiness = modelBusiness else {
            self.view?.showPopupView(withTitle: LocalizedConstants.generic_error_title_key.localized,
                                     withText: LocalizedConstants.generic_error_message_key.localized,
                                     withButton: LocalizedConstants.ok_key.localized,
                                     button2: nil,
                                     completion: nil)
            return
        }
        view?.didSetData(modelBusiness: modelBusiness)
    }
    
    private func validateName(_ name: String?) -> Bool {
        let textFieldErrorType = ServiceTextFieldValidation.validateName(name)
        switch textFieldErrorType {
        case .valid:
            view?.showNameTextFieldLabel(type: textFieldErrorType)
            return true
        case .empty_field_key, .invalid_name_key:
            view?.showNameTextFieldLabel(type: textFieldErrorType)
        default:
            break
        }
        return false
    }
    
    private func validatePhoneNumber(_ phoneNumber: String?) -> Bool {
        let textFieldErrorType = ServiceTextFieldValidation.validatePhoneNumber(phoneNumber)
        switch textFieldErrorType {
        case .valid:
            view?.showPhoneNumberTextFieldLabel(type: textFieldErrorType)
            return true
        case .empty_field_key, .invalid_phoneNumber_key:
            view?.showPhoneNumberTextFieldLabel(type: textFieldErrorType)
        default:
            break
        }
        return false
    }
    
    private func isValid(name: String?, phoneNumber: String?) -> Bool {
        let isValidateName = validateName(name)
        let isValidatePhoneNumber = validatePhoneNumber(phoneNumber)
        if  isValidateName == true && isValidatePhoneNumber == true {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - UI interaction methods
    func continueButtonTapped(name: String?, phoneNumber: String?) {
        if isValid(name: name, phoneNumber: phoneNumber) {
            customer = Customer(name: name, phoneNumber: phoneNumber)
            guard let customer = customer else { return }
            view?.showAlert(customer: customer)
        }
    }
    
    // MARK: - Public Interface
    func modifyModel(identifier: String, count: Int) {
        view?.modifyModel(identifier: identifier, count: count)
    }
    
    func checkAvailabilityButtonTapped(identifier: String?, bookedServices: [Service]?) {
        self.view?.startWaitingView()
        var servicesToBook: [ServiceToBook] = []
        bookedServices?.forEach({ servicesToBook.append(ServiceToBook(identifier: $0.identifier,
                                                                      count: $0.count)) })
        let modelCheckTurnsAvailabilityTask = ModelCheckTurnsAvailabilityTask(servicesToBook: servicesToBook)
        networkManager.getAvailableTimes(modelTask: modelCheckTurnsAvailabilityTask) { [weak self] modelCheckTurnsAvailability, error in
            guard let self = self else { return }
            if error as? MoyaError != nil {
                self.analyticsManager.trackConnectionFailedAlert(screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            if let error = error as? AppError {
                self.analyticsManager.trackAlert(alertTitle: error.title,
                                                 alertMessage: error.message,
                                                 screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
                                         completion: nil)
                return
            }
            if let modelCheckTurnsAvailability = modelCheckTurnsAvailability,
               let isAvailableDatesEmpty = modelCheckTurnsAvailability.availableDates?.isEmpty,
               !isAvailableDatesEmpty {
                self.trackAddAppointment(customer: self.customer, bookedServices: bookedServices)
                self.view?.stopWaitingView()
                self.delegate?.didSelectCheckAvailability(identifier: identifier,
                                                          name: self.modelBusiness?.name,
                                                          bookedServices: bookedServices,
                                                          modelCheckTurnsAvailability: modelCheckTurnsAvailability,
                                                          customer: self.customer)
            } else {
                self.analyticsManager.trackAlert(alertTitle: Constants.noAvailableDatesTitleAnalyticValue,
                                                 alertMessage: Constants.noAvailableDatesMessageAnalyticValue,
                                                 screenName: Constants.screenName)
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.no_available_dates_title_key.localized,
                                         withText: LocalizedConstants.no_available_dates_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized,
                                         button2: nil,
                                         completion: nil)
            }
        }
    }
}

private extension PresenterAddAppointment {
    func trackAddAppointment(customer: Customer?, bookedServices: [Service]?) {
        analyticsManager.track(eventKey: .buttonTapped, withProperties: [
            .buttonText: Constants.checkAvailabilityAnalyticValue,
            .screenName: Constants.screenName,
            .name: customer?.name ?? "",
            .phoneNumber: customer?.phoneNumber ?? "",
            .totalOfServices: String(bookedServices?.count ?? 0),
            .totalOfServicesTime: String(ServiceTimeCalculation.calculateDuration(to: bookedServices))
        ])
    }
}

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
    private weak var view: PresenterAddAppointmentView?
    var delegate: SelectButtonBusiness!
    var modelBusiness: ModelBusiness?
    let networkManager = NetworkManager()
    var customer: Customer?
    
    // MARK: - init Methods
    init(view: PresenterAddAppointmentView, modelBusiness: ModelBusiness?, delegate: SelectButtonBusiness) {
        self.view = view
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
        networkManager.getAvailableTimes(modelTask: modelCheckTurnsAvailabilityTask) { (modelCheckTurnsAvailability, error) in
            if error as? MoyaError != nil {
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.connection_failed_error_title_key.localized,
                                         withText: LocalizedConstants.connection_failed_error_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                         completion: nil)
                return
            }
            if let error = error as? AppError {
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: error.title,
                                         withText: error.message,
                                         withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                         completion: nil)
                return
            }
            if let modelCheckTurnsAvailability = modelCheckTurnsAvailability,
                let isAvailableDatesEmpty = modelCheckTurnsAvailability.availableDates?.isEmpty,
                !isAvailableDatesEmpty {
                self.view?.stopWaitingView()
                self.delegate.didSelectCheckAvailability(identifier: identifier, name: self.modelBusiness?.name,
                                                         bookedServices: bookedServices,
                                                         modelCheckTurnsAvailability: modelCheckTurnsAvailability,
                                                         customer: self.customer)
            } else {
                self.view?.stopWaitingView()
                self.view?.showPopupView(withTitle: LocalizedConstants.no_available_dates_title_key.localized,
                                         withText: LocalizedConstants.no_available_dates_message_key.localized,
                                         withButton: LocalizedConstants.ok_key.localized.localized, button2: nil,
                                         completion: nil)
            }
        }
    }
}

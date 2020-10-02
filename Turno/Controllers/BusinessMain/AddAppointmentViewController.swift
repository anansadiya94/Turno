//
//  AddAppointmentViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class AddAppointmentViewController: ParentViewController {
    
    // MARK: - Properties
    var presenterAddAppointment: PresenterAddAppointment!
    @UseAutoLayout var addAppointmentView = AddAppointmentView()
    
    override var navBarTitle: String {
        return "Add appointment"
    }
    
    var model: ModelBusiness?
    var services: [Service]?
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddAppointmentViewConstraints()
        addTarget()
        addObservers()
        hideKeyboardWhenTappedAround()
        configureTextFields()
        addToolBar()
        setTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        addAppointmentView.nameTextField.becomeFirstResponder()
    }
    
    // MARK: - Private methods
    private func setAddAppointmentViewConstraints() {
        self.view.addSubview(addAppointmentView)
        NSLayoutConstraint.activate([
            addAppointmentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addAppointmentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addAppointmentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            addAppointmentView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setTableView() {
        addAppointmentView.tableView.dataSource = self
        addAppointmentView.tableView.register(UINib(nibName: kServiceTableViewCellNib, bundle: nil),
                                        forCellReuseIdentifier: kServiceCellID)
    }
    
    private func addTarget() {
//        addAppointmentView?.checkAvailabilityButton.addTarget(self, action: #selector(checkAvailabilityButtonTapped), for: .touchUpInside)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(modifyModelAction(_:)),
                                               name: Business.modifyModel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appointmentConfirmedAction(_:)),
                                               name: Appointments.appointmentConfirmed, object: nil)
    }
    
    private func configureTextFields() {
        addAppointmentView.nameTextField.delegate = self
        addAppointmentView.phoneNumberTextField.delegate = self
    }
    
    private func addToolBar() {
        addCancelAndButtonsOnKeyboard(textField: addAppointmentView.phoneNumberTextField)
    }
    
    private func initServices(services: [Service]?) -> [Service]? {
        guard let servicesInit = services else { return nil }
        for index in 0..<servicesInit.count {
            servicesInit[index].count = 0
        }
        return servicesInit
    }
    
    // MARK: - UI interaction methods
    @objc func continueButtonTapped() {
        addAppointmentView.phoneNumberTextField.resignFirstResponder()
        presenterAddAppointment.continueButtonTapped(name: addAppointmentView.nameTextField.text,
                                                     phoneNumber: addAppointmentView.phoneNumberTextField.text ?? "")
    }
    
    @objc func cancelButtonTapped() {
        addAppointmentView.phoneNumberTextField.resignFirstResponder()
    }
    
    @objc func modifyModelAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let model = dict["model"] as? ModelModifyService {
                presenterAddAppointment.modifyModel(identifier: model.identifier, count: model.count)
            }
        }
    }
    
    @objc func appointmentConfirmedAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let bookedTurn = dict["bookedTurn"] as? Turn {
                presenterAddAppointment.appointmentConfirmed(bookedTurn: bookedTurn)
            }
        }
    }
    
    @objc func checkAvailabilityButtonTapped() {
        let bookedServices = services?.filter({ $0.count ?? 0 >= 1 })
        presenterAddAppointment.checkAvailabilityButtonTapped(identifier: model?.identifier, bookedServices: bookedServices)
    }
}

//TOOD IMPROVE ME
extension AddAppointmentViewController {
    func addCancelAndButtonsOnKeyboard(textField: UITextField?) {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel: UIBarButtonItem = UIBarButtonItem(title: LocalizedConstants.cancel_key.localized, style: .plain,
                                                      target: self, action: #selector(self.cancelButtonTapped))
        let done: UIBarButtonItem = UIBarButtonItem(title: LocalizedConstants.continue_key.localized, style: .done,
                                                    target: self, action: #selector(self.continueButtonTapped))
        
        cancel.tintColor = .primary
        done.tintColor = .primary
        
        let items = [cancel, flexSpace, done]
        toolbar.items = items
        toolbar.sizeToFit()
        
        textField?.inputAccessoryView = toolbar
    }
}

// MARK: - UITextFieldDelegate methods
extension AddAppointmentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addAppointmentView.phoneNumberTextField.becomeFirstResponder()
        return false
    }
}

// MARK: - PresenterAddAppointmentView methods
extension AddAppointmentViewController: PresenterAddAppointmentView {
    func didSetData(model: ModelBusiness) {
        self.services = initServices(services: model.services)
        
        DispatchQueue.main.async {
            self.addAppointmentView.tableView.reloadData()
        }
    }
    
    func modifyModel(identifier: String, count: Int) {
        services?.first(where: {$0.identifier == identifier})?.count = count
        
        var count: Int {
            var total = 0
            services?.forEach({total += $0.count ?? 0})
            return total
        }
        addAppointmentView.setCheckAvailabilityButton(count)
    }
    
    func appointmentConfirmed(bookedTurn: Turn) {
        //TODO
    }
    
    func showNameTextFieldLabel(type: TextFieldErrorType) {
        var isValid: Bool = true
        var message = ""
        switch type {
        case .valid:
            addAppointmentView.setTextFieldLabel(textFieldLabel: addAppointmentView.phoneNumberTextFieldLabel, isHidden: true)
        case .empty_field_key:
            isValid = false
            message = LocalizedConstants.empty_field_key.localized
        case .invalid_name_key:
            isValid = false
            message = LocalizedConstants.invalid_name_key.localized
        default:
            break
        }
        addAppointmentView.setTextFieldLabel(textFieldLabel: addAppointmentView.nameTextFieldLabel, message: message, isHidden: false)
        addAppointmentView.setTextFieldLayer(textField: addAppointmentView.nameTextField, isValid: isValid)
    }
    
    func showPhoneNumberTextFieldLabel(type: TextFieldErrorType) {
        var isValid: Bool = true
        var message = ""
        switch type {
        case .valid:
            addAppointmentView.setTextFieldLabel(textFieldLabel: addAppointmentView.phoneNumberTextFieldLabel, isHidden: true)
        case .empty_field_key:
            isValid = false
            message = LocalizedConstants.empty_field_key.localized
        case .invalid_phoneNumber_key:
            isValid = false
            message = LocalizedConstants.invalid_phoneNumber_key.localized
        default:
            break
        }
        addAppointmentView.setTextFieldLabel(textFieldLabel: addAppointmentView.phoneNumberTextFieldLabel, message: message, isHidden: false)
        addAppointmentView.setTextFieldLayer(textField: addAppointmentView.phoneNumberTextField, isValid: isValid)
    }
    
    func showAlert() {
        let modelAlertPopUp = ModelAlertPopup(title: LocalizedConstants.phone_number_question_key.localized,
                                              message: Preferences.getPrefsUser()?.phoneNumber,
                                              action1: LocalizedConstants.edit_key.localized,
                                              action2: LocalizedConstants.yes_key.localized)
        self.showPopup(withTitle: modelAlertPopUp.title, withText: modelAlertPopUp.message,
                       withButton: modelAlertPopUp.action1, button2: modelAlertPopUp.action2,
                       completion: { (action1, action2) in
                        if action1 != nil && action1 == true {
                            self.addAppointmentView.phoneNumberTextField.becomeFirstResponder()
                        }
                        if action2 != nil && action2 == true {
//                            self.addAppointmentView.alertYesButtonTapped()
                        }
                        
        })
    }
    
    func startWaitingView() {
        startWaiting()
    }
    
    func stopWaitingView() {
        stopWaiting()
    }
    
    func showPopupView(withTitle title: String?, withText text: String?, withButton button: String?, button2: String?, completion: ((Bool?, Bool?) -> Void)?) {
        showPopup(withTitle: title, withText: text, withButton: button, button2: button2, completion: completion)
    }
}

// MARK: - UITableViewDataSource methods
extension AddAppointmentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = addAppointmentView.tableView.dequeueReusableCell(withIdentifier: kServiceCellID, for: indexPath) as? ServiceTableViewCell,
            let service = services?[indexPath.row] {
            cell.config(service: service, type: .book)
            return cell
        }
        return UITableViewCell()
    }
}

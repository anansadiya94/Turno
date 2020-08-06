//
//  BusinessViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 18/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class BusinessViewController: ParentViewController {
    
    // MARK: - Properties
    var presenterBusiness: PresenterBusiness!
    @UseAutoLayout var businessView = BusinessView()
    
    var model: ModelBusiness?
    var services: [Service]?
    var turns: [Turn]?
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setBusinessViewConstraints()
        setTableView()
        addSwipeGestureRecognizer()
        addTargets()
        addObservers()
    }
    
    // MARK: - Private methods
    private func setBusinessViewConstraints() {
        self.view.addSubview(businessView)
        NSLayoutConstraint.activate([
            businessView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            businessView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            businessView.leftAnchor.constraint(equalTo: view.leftAnchor),
            businessView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setTableView() {
        businessView.tableView.dataSource = self
        businessView.tableView.delegate = self
        businessView.tableView.register(UINib(nibName: kServiceTableViewCellNib, bundle: nil),
                                        forCellReuseIdentifier: kServiceCellID)
        businessView.tableView.register(UINib(nibName: kBusinessAppointmentTableViewCellNib, bundle: nil),
                                        forCellReuseIdentifier: kBusinessAppoitmentCellID)
        businessView.tableView.register(UINib(nibName: kInformationTableViewCellNib, bundle: nil),
                                        forCellReuseIdentifier: kinformationCellID)
    }
    
    private func addSwipeGestureRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = .right
        businessView.tableView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeft.direction = .left
        businessView.tableView.addGestureRecognizer(swipeLeft)
    }
    
    private func addTargets() {
        businessView.segmentedControl.addTarget(self, action: #selector(handleSegmentControl), for: .valueChanged)
        businessView.checkAvailabilityButton.addTarget(self, action: #selector(checkAvailabilityButtonTapped), for: .touchUpInside)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(modifyModelAction(_:)),
                                               name: Business.modifyModel, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelTappedAction(_:)),
                                               name: Appointments.cancelTapped, object: nil)
    }
    
    private func serviceCell(_ indexPath: IndexPath) -> UITableViewCell {
        if let cell = businessView.tableView.dequeueReusableCell(withIdentifier: kServiceCellID, for: indexPath) as? ServiceTableViewCell,
            let service = services?[indexPath.row] {
            cell.config(service: service)
            return cell
        }
        return UITableViewCell()
    }
    
    private func appoitmentCell(_ indexPath: IndexPath) -> UITableViewCell {
        if let cell = businessView.tableView.dequeueReusableCell(withIdentifier: kBusinessAppoitmentCellID,
                                                                 for: indexPath) as? BusinessAppointmentTableViewCell,
            let turn = turns?[indexPath.row] {
            cell.config(turn: turn)
            return cell
        }
        return UITableViewCell()
    }
    
    private func informationCell(_ indexPath: IndexPath) -> UITableViewCell {
        if let cell = businessView.tableView.dequeueReusableCell(withIdentifier: kinformationCellID,
                                                                 for: indexPath) as? InformationTableViewCell {
            switch indexPath.row {
            case 0:
                cell.config(type: .location, text: model?.address ?? "")
            case 1:
                cell.config(type: .email, text: "TODO")
            case 2:
                cell.config(type: .telephone, text: model?.phone ?? "")
            case 3:
                cell.config(type: .schedule, text: "TODO")
            case 4:
                cell.config(type: .description, text: model?.description ?? "")
            default:
                break
            }
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - UI interaction methods
    @objc func modifyModelAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let model = dict["model"] as? ModelModifyService {
                presenterBusiness.modifyModel(identifier: model.identifier, count: model.count)
            }
        }
    }
    
    @objc func cancelTappedAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let identifier = dict["identifier"] as? String {
                presenterBusiness.cancelTapped(turnId: identifier)
            }
        }
    }
    
    @objc func checkAvailabilityButtonTapped() {
        presenterBusiness.checkAvailabilityButtonTapped(identifier: model?.identifier, bookedServices: services)
    }
    
    @objc func swipedRight() {
        if businessView.segmentedControl.selectedSegmentIndex > 0 {
            businessView.segmentedControl.selectedSegmentIndex -= 1
            handleSegmentControl()
        }
    }
    
    @objc func swipedLeft() {
        if businessView.segmentedControl.selectedSegmentIndex < businessView.segmentedControl.numberOfSegments {
            businessView.segmentedControl.selectedSegmentIndex += 1
            handleSegmentControl()
        }
    }
    
    // MARK: - UI interaction methods
    @objc private func handleSegmentControl() {
        businessView.setView()
        businessView.tableView.reloadData()
    }
}

// MARK: - PresenterBusinessView methods
extension BusinessViewController: PresenterBusinessView {
    func didSetData(model: ModelBusiness) {
        self.model = model
        self.turns = model.turns
        
        guard let servicesInit = model.services else { return }
        for index in 0..<servicesInit.count {
            servicesInit[index].count = 0
        }
        self.services = servicesInit
        
        DispatchQueue.main.async {
            self.navigationItem.title = model.name
            self.businessView.setImage(image: model.image)
            self.businessView.tableView.reloadData()
        }
    }
    
    func modifyModel(identifier: String, count: Int) {
        services?.first(where: {$0.identifier == identifier})?.count = count
        
        var count: Int {
            var total = 0
            services?.forEach({total += $0.count ?? 0})
            return total
        }
        businessView.setCheckAvailabilityButton(count)
    }
    
    func openMap(model: ModelLocation) {
        self.openMaps(model: model)
    }
    
    func send(email: String) {
        self.sendEmail(email)
    }
    
    func call(_ number: String) {
        self.callNumber(number)
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
extension BusinessViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch businessView.segmentedControl.selectedSegmentIndex {
        case 0:
            return services?.count ?? 0
        case 1:
            return turns?.count ?? 0
        case 2:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch businessView.segmentedControl.selectedSegmentIndex {
        case 0:
            return serviceCell(indexPath)
        case 1:
            return appoitmentCell(indexPath)
        case 2:
            return informationCell(indexPath)
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate methods
extension BusinessViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch businessView.segmentedControl.selectedSegmentIndex {
        case 2:
            switch indexPath.row {
            case 0:
                presenterBusiness.openMaps(model: ModelLocation(name: model?.name ?? "",
                                                                location: Location(lat: model?.latitude, lng: model?.longitude)))
            case 1:
                if let email = model?.email {
                    presenterBusiness.send(email: email)
                }
            case 2:
                if let phone = model?.phone {
                    presenterBusiness.call(phone)
                }
            default:
                break
            }
        default:
            break
        }
    }
}

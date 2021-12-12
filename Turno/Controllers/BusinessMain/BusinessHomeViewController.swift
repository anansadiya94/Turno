//
//  BusinessHomeViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import CalendarKit

class BusinessHomeViewController: DayViewController {
    
    // MARK: - Properties
    var presenterHome: PresenterBusinessHome!
    private var turns: [Turn]?
    private var modelBusiness: ModelBusiness?
    
    var waitingView: LoadingViewController?
    private var isShownPopup = false
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldForceUpdate()
        setNavigationBar()
        edgesForExtendedLayout = UIRectEdge.bottom
        var calendarStyle = CalendarStyle()
        var timelineStyle = TimelineStyle()
        timelineStyle.verticalDiff = 150
        calendarStyle.timeline = timelineStyle
        updateStyle(calendarStyle)
        dayView.autoScrollToFirstEvent = true
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenterHome.fetchMyBookings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenterHome.trackScreen()
    }
    
    // MARK: - DayViewController methods
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        guard let turns = turns else { return [] }
        
        var events: [Event] = []
        
        for turn in turns {
            if let services = turn.services,
               let beginningTime = turn.dateTimeUTC {
                let servicesDuration = ServiceTimeCalculation.calculateDuration(to: services)
                guard let endDate = Calendar.current.date(byAdding: .minute, value: servicesDuration, to: beginningTime) else { break }
                
                var data = turn.userName ?? ""
                let startDateHour = beginningTime.toString().toDisplayableDate(type: .hour)
                let endDateHour = endDate.toString().toDisplayableDate(type: .hour)
                if let startDateHour = startDateHour,
                   let endDateHour = endDateHour,
                   let userName = turn.userName {
                    data = "\(startDateHour):\(endDateHour) - \(userName)"
                }
                
                events.append(createEvent(turn: turn,
                                          data: data,
                                          startDate: beginningTime,
                                          endDate: endDate.addingTimeInterval(-1)))
            }
        }
        
        return events
    }
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        if let turn = descriptor.userInfo as? Turn {
            presenterHome.showAppointmentTapped(turn: turn)
        }
    }
    
    // MARK: - Private methods
    private func shouldForceUpdate() {
        presenterHome.shouldForceUpdate { [weak self] shouldForceUpdate in
            guard let self = self else { return }
            if shouldForceUpdate {
                self.showForceUpdatePopup()
            }
        }
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .primary
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain, target: self, action: #selector(addTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                                           style: .plain, target: self, action: #selector(refreshTapped))
    }
    
    private func createEvent(turn: Turn?, data: String, startDate: Date, endDate: Date) -> Event {
        let event = Event()
        event.userInfo = turn
        event.startDate = startDate
        event.endDate = endDate
        event.color = .primary
        event.text = data
        
        let duration = ServiceTimeCalculation.calculateDuration(to: turn?.services)
        switch duration {
        case ...10:
            event.font = Fonts.Regular10
        case 11..<31:
            event.font = Fonts.Regular15
        default:
            event.font = Fonts.Regular20
        }
        
        return event
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(appointmentConfirmedAction(_:)),
                                               name: Appointments.appointmentConfirmed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func handleEmptyState() {
        self.showToast(message: LocalizedConstants.no_turns_business_message_key.localized)
    }
    
    // MARK: - UI interaction methods
    @objc func addTapped() {
        presenterHome.addAppointmentTapped()
    }
    
    @objc func refreshTapped() {
        presenterHome.refreshTapped()
    }
    
    @objc func appointmentConfirmedAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let bookedTurn = dict["bookedTurn"] as? Turn {
                presenterHome.appointmentConfirmed(bookedTurn: bookedTurn)
            }
        }
    }
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        shouldForceUpdate()
    }
}

// MARK: - PresenterBusinessHomeView methods
extension BusinessHomeViewController: PresenterBusinessHomeView {
    func didSetData(modelBusiness: ModelBusiness, modelMyBookings: ModelMyBookings) {
        self.modelBusiness = modelBusiness
        if let myBookings = modelMyBookings.myBookings {
            self.turns = []
            myBookings.forEach({
                $0.value.forEach({
                    self.turns?.append($0)
                })
            })
        }
        DispatchQueue.main.async {
            self.navigationItem.title = modelBusiness.name
        }
        if let turns = self.turns, turns.isEmpty {
            handleEmptyState()
        }
        reloadData()
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
    
    func appointmentConfirmed(bookedTurn: Turn) {
        turns?.append(bookedTurn)
        reloadData()
    }
}

extension BusinessHomeViewController {
    func startWaiting(color: UIColor = .white) {
        DispatchQueue.main.async {
            if self.waitingView == nil {
                self.waitingView = LoadingViewController(containerView: self.view)
            }
            self.view.subviews.filter { $0.isKind(of: LoadingViewController.self) }
                .forEach { $0.removeFromSuperview() }
            self.waitingView?.start()
        }
    }
    
    func stopWaiting() {
        DispatchQueue.main.async {
            self.waitingView?.stop()
        }
    }
    
    func showPopup(withTitle title: String?, withText text: String?, withButton button: String?, button2: String? = nil, completion: ((Bool?, Bool?) -> Void)?) {
        if !isShownPopup, presentedViewController == nil {
            isShownPopup = true
            
            // Obscure background
            let alphaView = UIView(frame: self.view.frame)
            alphaView.backgroundColor = .blackAlpha15
            alphaView.alpha = 1.0
            self.view.addSubview(alphaView)
            
            // Popup
            let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertController.Style.alert)
            
            // First action
            alert.addAction(UIAlertAction(title: button, style: .default, handler: { [weak self] _ in
                self?.view.subviews.last?.removeFromSuperview()
                self?.isShownPopup = false
                completion?(true, nil)
            }))
            
            // Second Action
            if let button2 = button2 {
                alert.addAction(UIAlertAction(title: button2, style: .default, handler: { [weak self] _ in
                    self?.view.subviews.last?.removeFromSuperview()
                    self?.isShownPopup = false
                    completion?(nil, true)
                }))
            }
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            debugPrint("There is still a popup ...")
        }
    }
    
    func showForceUpdatePopup() {
        stopWaiting()
        DispatchQueue.main.async {
            self.showPopup(withTitle: LocalizedConstants.force_update_title_key.localized,
                           withText: LocalizedConstants.force_update_message_key.localized,
                           withButton: LocalizedConstants.force_update_action_key.localized) { _, _ in
                if let url = URL(string: "itms-apps://apple.com/app/id1535076357") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    func showToast(message: String) {
        let toastLabel = CustomLabel()
        toastLabel.labelTheme = RegularTheme(label: "   \(message)   ", fontSize: 12.0, textColor: .white, textAlignment: .center)
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.backgroundColor = UIColor.primary
        
        guard let optionalWindow = UIApplication.shared.delegate?.window, let window = optionalWindow else { return }
        window.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            toastLabel.heightAnchor.constraint(equalToConstant: 40),
            toastLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90.0)
        ])
        
        UIView.animate(withDuration: 2.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {_ in
            toastLabel.removeFromSuperview()
        })
    }
}

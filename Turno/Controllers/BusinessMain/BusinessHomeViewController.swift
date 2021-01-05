//
//  BusinessHomeViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import CalendarKit
import DateToolsSwift

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
        setNavigationBar()
        edgesForExtendedLayout = UIRectEdge.bottom
        dayView.autoScrollToFirstEvent = true
        addObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        presenterHome.fetchMyBookings()
    }
    
    // MARK: - DayViewController methods
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        guard let turns = turns else { return [] }
        
        var events: [Event] = []
        
        for turn in turns {
            if let services = turn.services,
               let beginningTime = turn.dateTimeUTC?.toDate() {
                let chunk = TimeChunk.dateComponents(minutes: ServiceTimeCalculation.calculateDuration(to: services))
                events.append(createEvent(turn: turn,
                                          data: turn.userName ?? "",
                                          datePeriod: TimePeriod(beginning: beginningTime,
                                                                 chunk: chunk)))
            }
        }
        
        return events
    }
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
        if let turn = descriptor.userInfo as? Turn {
            presenterHome.showAppointmentTapped(turn: turn)
        }
    }
    
    // MARK: - Private methods
    private func setNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .primary
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain, target: self, action: #selector(addTapped))
    }
    
    private func createEvent(turn: Turn?, data: String, datePeriod: TimePeriod) -> Event {
        let event = Event()
        event.userInfo = turn
        
        let datePeriod = datePeriod
        event.startDate = datePeriod.beginning!
        event.endDate = datePeriod.end!
        
        event.text = data
        event.color = .primary
        
        return event
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(appointmentConfirmedAction(_:)),
                                               name: Appointments.appointmentConfirmed, object: nil)
    }
    
    private func handleEmptyState() {
        self.showPopup(withTitle: LocalizedConstants.no_turns_error_title_key.localized,
                       withText: LocalizedConstants.no_turns_error_message_key.localized,
                       withButton: LocalizedConstants.ok_key.localized,
                       completion: nil)
    }
    
    // MARK: - UI interaction methods
    @objc func addTapped() {
        presenterHome.addAppointmentTapped()
    }
    
    @objc func appointmentConfirmedAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let bookedTurn = dict["bookedTurn"] as? Turn {
                presenterHome.appointmentConfirmed(bookedTurn: bookedTurn)
            }
        }
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
        if !isShownPopup, presentedViewController == nil, UIApplication.shared.applicationState == .active {
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
}

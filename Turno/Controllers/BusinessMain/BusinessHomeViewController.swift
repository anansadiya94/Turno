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
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        edgesForExtendedLayout = UIRectEdge.bottom
        dayView.autoScrollToFirstEvent = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "TODO"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = ""
    }
    
    // MARK: - DayViewController methods
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        guard let turns = turns else { return [] } // TODO: When no turns?
        
        var events: [Event] = []
        
        for turn in turns {
            if let identifier = turn.identifier,
               let services = turn.services,
               let beginningTime = turn.dateTimeUTC?.toDate() {
                let chunk = TimeChunk.dateComponents(minutes: ServiceTimeCalculation.calculateDuration(to: services))
                events.append(createEvent(turn: turn,
                                          data: identifier,
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
    
    // MARK: - UI interaction methods
    @objc func addTapped() {
        presenterHome.addAppointmentTapped()
    }
}

// MARK: - PresenterBusinessHomeView methods
extension BusinessHomeViewController: PresenterBusinessHomeView {
    func didSetData(turns: [Turn]) {
        self.turns = turns
        reloadData()
    }
}

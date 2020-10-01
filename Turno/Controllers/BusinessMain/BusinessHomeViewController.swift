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
    
    var turns = [
        Turn(identifier: "dummy1", dateTimeUTC: "2020-09-30T09:00:00", services: [
            Service(identifier: "1", serviceName: "Test1", durationInMinutes: 10, count: 1),
            Service(identifier: "2", serviceName: "Test2", durationInMinutes: 20, count: 2),
            Service(identifier: "3", serviceName: "Test3", durationInMinutes: 30, count: 3),
            Service(identifier: "4", serviceName: "Test4", durationInMinutes: 10, count: 4)
        ]),
        Turn(identifier: "dummy2", dateTimeUTC: "2020-09-30T16:00:00", services: [
            Service(identifier: "1", serviceName: "Test11", durationInMinutes: 10, count: 3)
        ]),
        Turn(identifier: "dummy3", dateTimeUTC: "2020-10-1T09:00:00", services: [
            Service(identifier: "1", serviceName: "Test111", durationInMinutes: 10, count: 1),
            Service(identifier: "2", serviceName: "Test222", durationInMinutes: 20, count: 2)
        ]),
        Turn(identifier: "dummy4", dateTimeUTC: "2020-10-2T09:00:00", services: [
            Service(identifier: "1", serviceName: "Test1111", durationInMinutes: 10, count: 1),
            Service(identifier: "2", serviceName: "Test2222", durationInMinutes: 20, count: 2),
            Service(identifier: "3", serviceName: "Test3333", durationInMinutes: 30, count: 3)
        ])
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        edgesForExtendedLayout = UIRectEdge.bottom
        dayView.autoScrollToFirstEvent = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Business home"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = ""
    }
    
    // MARK: - Private methods
    private func setNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .primary
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        presenterHome.addAppointmentTapped()
    }
    
    // Return an array of EventDescriptors for particular date
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        var events = [Event]()
        
        for turn in turns {
            if let identifier = turn.identifier,
               let services = turn.services,
               let beginningTime = turn.dateTimeUTC?.toDate() {
                events.append(createEvent(turn: turn,
                                          data: identifier,
                                          datePeriod: TimePeriod(beginning: beginningTime,
                                                                 chunk: TimeChunk.dateComponents(minutes: calculateDuration(to: services)))))
            }
        }
        
        return events
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
    
    private func calculateDuration(to bookedServices: [Service]?) -> Int {
        var duration = 0
        guard let bookedServices = bookedServices else {
            return duration
        }
        bookedServices.forEach({
            if let count = $0.count, let durationInMinutes = $0.durationInMinutes {
                duration += (count * durationInMinutes)
            }
        })
        return duration
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
}

// MARK: - PresenterBusinessHomeView methods
extension BusinessHomeViewController: PresenterBusinessHomeView {
    func didSetData() {
        reloadData()
    }
}

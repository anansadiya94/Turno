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
    
    var data = [
        ["Elias",
        "SERVICES"],
        ["Ruber",
        "SERVICES"],
        ["Rani",
        "SERVICES"],
        ["Tamer",
        "SERVICES"]]

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
        let nextOffset = 90
        var date = date.add(TimeChunk.dateComponents(hours: 11))
        var events = [Event]()

        for user in data {
            events.append(createEvent(data: user, datePeriod: TimePeriod(beginning: date,
                                                                         chunk: TimeChunk.dateComponents(minutes: 60))))
            date = date.add(TimeChunk.dateComponents(minutes: nextOffset))
        }

        return events
    }

    private func createEvent(data: [String], datePeriod: TimePeriod) -> Event {
        let event = Event()
        let datePeriod = datePeriod

        event.startDate = datePeriod.beginning!
        event.endDate = datePeriod.end!

        var info = data

        let timezone = TimeZone.ReferenceType.default
        info.append(datePeriod.beginning!.format(with: "dd.MM.YYYY", timeZone: timezone))
        info.append("\(datePeriod.beginning!.format(with: "HH:mm", timeZone: timezone)) - \(datePeriod.end!.format(with: "HH:mm", timeZone: timezone))")
        event.text = info.reduce("", {$0 + $1 + "\n"})
        event.color = .red

        return event
    }
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
//        print("Event has been selected: \(eventView.descriptor)")
        presenterHome.showAppointmentTapped()
    }
}

// MARK: - PresenterBusinessHomeView methods
extension BusinessHomeViewController: PresenterBusinessHomeView {
    func didSetData() {
        reloadData()
    }
}

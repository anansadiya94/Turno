//
//  BusinessAppointmentTableViewCell.swift
//  Turno
//
//  Created by Anan Sadiya on 20/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class BusinessAppointmentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var dateImageView: UIImageView!
    @IBOutlet weak var dayLabel: CustomLabel!
    @IBOutlet weak var dateLabel: CustomLabel!
    @IBOutlet weak var servicesImageView: UIImageView!
    @IBOutlet weak var servicesTableView: UITableView!
    @IBOutlet weak var cancelButton: RoundedCustomButton!
    @IBOutlet weak var servicesTableViewHeight: NSLayoutConstraint!
    
    var identifier: String?
    var services: [Service]?
    
    // MARK: - UITableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        baseView.backgroundColor = .white
        servicesTableView.dataSource = self
        servicesTableView.alwaysBounceVertical = true
        servicesTableView.automaticallyAdjustsScrollIndicatorInsets = false
        servicesTableView.contentInsetAdjustmentBehavior = .never
        servicesTableView.showsVerticalScrollIndicator = false
        servicesTableView.separatorStyle = .none
        servicesTableView.tableFooterView = UIView()
        servicesTableView.register(UINib(nibName: kServiceTableViewCellNib, bundle: nil),
                                             forCellReuseIdentifier: kServiceCellID)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpView()
    }
    
    // MARK: - Private methods
    private func setUpView() {
        baseView.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.5).cgColor, shadowRadius: 5,
                           shadowOffset: CGSize(width: 0.5, height: 1), shadowOpacity: 1)
        baseView.layer.cornerRadius = 5
        dateImageView.tintColor = .black
        servicesImageView.tintColor = .black
        cancelButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.cancel_key.localized,
                                                    backgroundColor: UIColor.red.withAlphaComponent(0.5))
    }
    
    private func setServicesLabel(from turn: Turn) {
        services = turn.services
        servicesTableViewHeight.constant = CGFloat(turn.services?.count ?? 0) * 40.0
        servicesTableView.reloadData()
    }
    
    // TODO: Refactor
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
    
    // MARK: - UI interaction methods
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if let identifier = self.identifier {
            let dict: [String: String] = ["identifier": identifier]
            NotificationCenter.default.post(name: Appointments.cancelTapped, object: nil,
                                            userInfo: dict)
        }
    }
    
    // MARK: - Public Interface
    func config(turn: Turn) {
        self.identifier = turn.identifier
        
        dayLabel.labelTheme = BoldTheme(label: turn.dateTimeUTC?.toDisplayDay() ?? "",
                                         fontSize: 20,
                                         textColor: .black,
                                         textAlignment: .left)
        
        let date = turn.dateTimeUTC?.toDisplayableDate(type: .date) ?? ""
        let starTime = turn.dateTimeUTC?.toDisplayableDate(type: .hour) ?? ""
        let bookedServicesDuration = self.calculateDuration(to: turn.services)
        let endTimeDate = turn.dateTimeUTC?.calculateEndDate(adding: bookedServicesDuration)
        let endTime = endTimeDate?.toDisplayableDate(type: .hour) ?? ""
        
        let dateLabelString = date + ", " + starTime + "-" + endTime
        dateLabel.labelTheme = RegularTheme(label: dateLabelString,
                                            fontSize: 20,
                                            textColor: .black,
                                            textAlignment: .left)
        
        setServicesLabel(from: turn)
    }
}

extension BusinessAppointmentTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = servicesTableView.dequeueReusableCell(withIdentifier: kServiceCellID, for: indexPath) as? ServiceTableViewCell,
            let service = services?[indexPath.row] {
            cell.config(service: service, type: .present)
            return cell
        }
        return UITableViewCell()
    }
}

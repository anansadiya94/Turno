//
//  AppointmentTableViewCell.swift
//  Turno
//
//  Created by Anan Sadiya on 07/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Kingfisher

class AppointmentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var dateImageView: UIImageView!
    @IBOutlet weak var dayLabel: CustomLabel!
    @IBOutlet weak var dateLabel: CustomLabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: CustomLabel!
    @IBOutlet weak var servicesImageView: UIImageView!
    @IBOutlet weak var servicesTableView: UITableView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var cancelButton: RoundedCustomButton!
    @IBOutlet weak var callNowButton: RoundedCustomButton!
    @IBOutlet weak var servicesTableViewHeight: NSLayoutConstraint!
    
    var identifier: String?
    var phone: String?
    var services: [Service]?
    
    // MARK: - UICollectionViewCell
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
        titleView.backgroundColor = .primaryAlpha75
        titleView.roundCorners(corners: [.topRight, .topLeft], radius: 5.0)
        thumbnailImage.layer.cornerRadius = thumbnailImage.frame.height/2
        thumbnailImage.clipsToBounds = true
        thumbnailImage.backgroundColor = UIColor.lightGray
        thumbnailImage.contentMode = .scaleAspectFill
        dateImageView.tintColor = .black
        locationImageView.tintColor = .black
        servicesImageView.tintColor = .black
        buttonsView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 5.0)
        cancelButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.cancel_key.localized,
                                                    backgroundColor: UIColor.red.withAlphaComponent(0.3))
        callNowButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.call_now_key.localized, backgroundColor: .white,
                                                     borderColor: UIColor.primary.cgColor, titleColor: .primary)
    }
    
    private func setThumbnailImageView(url: String?) {
        thumbnailImage.setThumbnailImageView(from: url)
    }
    
    private func setServicesTableView(from model: ModelAppointment) {
        services = model.turn?.services
        servicesTableViewHeight.constant = CGFloat(model.turn?.services?.count ?? 0) * 50.0
        servicesTableView.reloadData()
    }
    
    // MARK: - UI interaction methods
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if let identifier = self.identifier {
            let dict: [String: String] = ["identifier": identifier]
            NotificationCenter.default.post(name: Appointments.cancelTapped, object: nil,
                                            userInfo: dict)
        }
    }
    
    @IBAction func callNowTapped(_ sender: Any) {
        if let phone = self.phone {
            let dict: [String: String] = ["phone": phone]
            NotificationCenter.default.post(name: Appointments.callNowTapped, object: nil,
                                            userInfo: dict)
        }
    }
    
    // MARK: - Public Interface
    func config(model: ModelAppointment) {
        self.identifier = model.turn?.identifier
        self.phone = model.phone
        setThumbnailImageView(url: model.image)
        titleLabel.labelTheme = BoldTheme(label: model.name ?? "",
                                          fontSize: 30,
                                          textColor: .white,
                                          textAlignment: .center)
        dayLabel.labelTheme = BoldTheme(label: model.turn?.dateTimeUTC?.toString().toDisplayDay() ?? "",
                                         fontSize: 18,
                                         textColor: .black,
                                         textAlignment: .natural)
        
        let date = model.turn?.dateTimeUTC?.toString().toDisplayableDate(type: .date) ?? ""
        let starTime = model.turn?.dateTimeUTC?.toString().toDisplayableDate(type: .hour) ?? ""
        let bookedServicesDuration = ServiceTimeCalculation.calculateDuration(to: model.turn?.services)
        let endTimeDate = model.turn?.dateTimeUTC?.toString().calculateEndDate(adding: bookedServicesDuration)
        let endTime = endTimeDate?.toDisplayableDate(type: .hour) ?? ""
        
        let dateLabelString = date + ", " + starTime + "-" + endTime
        dateLabel.labelTheme = RegularTheme(label: dateLabelString,
                                            fontSize: 18,
                                            textColor: .black,
                                            textAlignment: .natural)
        
        locationLabel.labelTheme = BoldTheme(label: model.address ?? "",
                                             fontSize: 18,
                                             textColor: .black,
                                             textAlignment: .natural)
        setServicesTableView(from: model)
    }
}

extension AppointmentTableViewCell: UITableViewDataSource {
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

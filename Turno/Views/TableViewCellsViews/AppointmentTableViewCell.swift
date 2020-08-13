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
    @IBOutlet weak var dateLabel: CustomLabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: CustomLabel!
    @IBOutlet weak var servicesImageView: UIImageView!
    @IBOutlet weak var servicesLabel: CustomLabel!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var cancelButton: RoundedCustomButton!
    @IBOutlet weak var callNowButton: RoundedCustomButton!
    
    var identifier: String?
    var phone: String?
    
    // MARK: - UICollectionViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
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
                                                    backgroundColor: UIColor.red.withAlphaComponent(0.5))
        callNowButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.call_now_key.localized, backgroundColor: .white,
                                                     borderColor: UIColor.primary.cgColor, titleColor: .primary)
    }
    
    private func setThumbnailImageView(url: String?) {
        thumbnailImage.setThumbnailImageView(from: url)
    }
    
    private func setServicesLabel(from model: ModelAppointment) {
        var services: [String] = []
        model.turn?.services?.forEach({
            if let serviceName = $0.serviceName {
                services.append(serviceName)
            }
        })
        let joined = services.joined(separator: ", ")
        
        servicesLabel.labelTheme = BoldTheme(label: joined,
                                             fontSize: 20,
                                             textColor: .black,
                                             textAlignment: .left)
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
        dateLabel.labelTheme = BoldTheme(label: model.turn?.dateTimeUTC?.toDisplayableDate(type: .dateAndHour) ?? "",
                                         fontSize: 20,
                                         textColor: .black,
                                         textAlignment: .left)
        locationLabel.labelTheme = BoldTheme(label: "TODO",
                                             fontSize: 20,
                                             textColor: .black,
                                             textAlignment: .left)
        setServicesLabel(from: model)
    }
}

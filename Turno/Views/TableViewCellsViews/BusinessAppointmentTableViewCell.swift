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
    @IBOutlet weak var dateLabel: CustomLabel!
    @IBOutlet weak var servicesImageView: UIImageView!
    @IBOutlet weak var servicesLabel: CustomLabel!
    @IBOutlet weak var cancelButton: RoundedCustomButton!
    
    var identifier: String?
    
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
        dateImageView.tintColor = .black
        servicesImageView.tintColor = .black
        cancelButton.buttonTheme = RoundedBaseTheme(label: LocalizedConstants.cancel_key.localized,
                                                    backgroundColor: UIColor.red.withAlphaComponent(0.5))
    }
    
    private func setServicesLabel(from turn: Turn) {
        var services: [String] = []
        turn.services?.forEach({
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
    
    // MARK: - Public Interface
    func config(turn: Turn) {
        self.identifier = turn.identifier
        
        dateLabel.labelTheme = BoldTheme(label: turn.dateTimeUTC?.toDisplayableDate() ?? "",
                                         fontSize: 20,
                                         textColor: .black,
                                         textAlignment: .left)
        setServicesLabel(from: turn)
    }
}

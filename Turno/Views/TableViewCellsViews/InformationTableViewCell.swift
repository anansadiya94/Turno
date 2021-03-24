//
//  InformationTableViewCell.swift
//  Turno
//
//  Created by Anan Sadiya on 22/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

enum InformationTableViewCellType {
    case location
    case email
    case telephone
    case schedule
    case description
    
    var logo: UIImage? {
        switch self {
        case .location:
            return UIImage(systemName: "mappin")
        case .email:
            return UIImage(systemName: "envelope")
        case .telephone:
            return UIImage(systemName: "phone")
        case .schedule:
            return UIImage(systemName: "clock")
        case .description:
            return UIImage(systemName: "info")
        }
    }
    
    var isClickable: Bool {
        switch self {
        case .location, .email, .telephone:
            return true
        default:
            return false
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .location, .email, .telephone:
            return UIColor.blue
        default:
            return UIColor.black
        }
    }
}

class InformationTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var informationImageView: UIImageView!
    @IBOutlet weak var informationLabel: CustomLabel!
    
    // MARK: - UITableViewCell
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
        informationImageView.tintColor = .black
    }
    
    // MARK: - Public Interface
    func config(type: InformationTableViewCellType, text: String) {
        informationImageView.image = type.logo
        informationLabel.labelTheme = RegularTheme(label: text, fontSize: 17, textColor: type.textColor,
                                                   textAlignment: .natural, numberOfLines: 0)
    }
}

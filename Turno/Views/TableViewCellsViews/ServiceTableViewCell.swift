//
//  ServiceTableViewCell.swift
//  Turno
//
//  Created by Anan Sadiya on 19/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

let kMaxServices: Int = 5

enum ServiceTableViewCellType {
    case book
    case booked
    case present
}

class ServiceTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var nameLabel: CustomLabel!
    @IBOutlet weak var durationLabel: CustomLabel!
    @IBOutlet weak var countLabel: CustomLabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    var identifier: String?
    var count: Int?
    var type: ServiceTableViewCellType?
    
    // MARK: - UICollectionViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    // MARK: - Private methods
    private func setButtons(_ count: Int) {
        if let type = type {
            switch type {
            case .book:
                durationLabel.isHidden = false
                plusButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
                minusButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
                switch count {
                case 0:
                    minusButton.isEnabled = false
                    minusButton.tintColor = UIColor.red.withAlphaComponent(0.5)
                    plusButton.isEnabled = true
                    plusButton.tintColor = .primary
                case 1...kMaxServices-1:
                    minusButton.isEnabled =  true
                    minusButton.tintColor = .red
                    plusButton.isEnabled = true
                    plusButton.tintColor = .primary
                case kMaxServices:
                    plusButton.isEnabled = false
                    plusButton.tintColor = UIColor.primary.withAlphaComponent(0.5)
                default:
                    break
                }
            case .booked:
                durationLabel.isHidden = true
                plusButton.isEnabled = false
                plusButton.setImage(nil, for: .normal)
                minusButton.isEnabled = false
                minusButton.setImage(nil, for: .normal)
            case .present:
                durationLabel.isHidden = true
                plusButton.isEnabled = false
                plusButton.setImage(nil, for: .normal)
                minusButton.isEnabled = false
                minusButton.setImage(nil, for: .normal)
            }
        }
    }
    
    private func setCountLabel(_ count: Int) {
        if let type = type {
            switch type {
            case .booked, .present:
                countLabel.layer.masksToBounds = true
                countLabel.layer.cornerRadius = countLabel.frame.width/2
                countLabel.backgroundColor = .primary
                countLabel.labelTheme = RegularTheme(label: "\(count)",
                    fontSize: 17,
                    textColor: .white,
                    textAlignment: .center)
            default:
                countLabel.labelTheme = RegularTheme(label: "\(count)",
                    fontSize: 17,
                    textColor: .black,
                    textAlignment: .center)
            }
        }
    }
    
    private func modifyModel(_ count: Int) {
        guard let identifier = identifier else { return }
        let modelModifyService = ModelModifyService(identifier: identifier, count: count)
        let modelDict: [String: ModelModifyService] = ["model": modelModifyService]
        NotificationCenter.default.post(name: Business.modifyModel, object: nil, userInfo: modelDict)
    }
    
    // MARK: - UI interaction methods
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        guard var safeCount = count else { return }
        if safeCount > 0 {
            safeCount -= 1
            count = safeCount
            setCountLabel(safeCount)
            setButtons(safeCount)
            modifyModel(safeCount)
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        guard var safeCount = count else { return }
        if safeCount < kMaxServices {
            safeCount += 1
            count = safeCount
            setCountLabel(safeCount)
            setButtons(safeCount)
            modifyModel(safeCount)
        }
    }
    
    // MARK: - Public Interface
    func config(service: Service, type: ServiceTableViewCellType) {
        self.identifier = service.identifier
        self.type = type
        nameLabel.labelTheme = SemiBoldTheme(label: service.serviceName ?? "",
                                             fontSize: 17,
                                             textColor: .black,
                                             textAlignment: .left)
        durationLabel.labelTheme = RegularTheme(label: "\(service.durationInMinutes ?? 0)m",
            fontSize: 17,
            textColor: .black,
            textAlignment: .left)
        
        self.count = service.count
        setCountLabel(self.count ?? 0)
        setButtons(self.count ?? 0)
    }
}

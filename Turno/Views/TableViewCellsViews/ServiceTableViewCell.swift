//
//  ServiceTableViewCell.swift
//  Turno
//
//  Created by Anan Sadiya on 19/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

let kMaxServices: Int = 5

class ServiceTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var nameLabel: CustomLabel!
    @IBOutlet weak var durationLabel: CustomLabel!
    @IBOutlet weak var countLabel: CustomLabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    var identifier: String?
    var count: Int?
    
    // MARK: - UICollectionViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    // MARK: - Private methods
    private func setButtons(_ count: Int) {
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
    }
    
    private func setCountLabel(_ count: Int) {
        countLabel.labelTheme = RegularTheme(label: "\(count)",
            fontSize: 17,
            textColor: .black,
            textAlignment: .center)
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
    func config(service: Service) {
        self.identifier = service.identifier
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

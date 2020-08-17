//
//  AvailableTurnDayCollectionViewCell.swift
//  Turno
//
//  Created by Anan Sadiya on 09/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class AvailableTurnDayCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var dayLabel: CustomLabel!
    @IBOutlet weak var dateLabel: CustomLabel!
    
    // MARK: - UICollectionViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpView()
    }
    
    // MARK: - Private methods
    private func setUpView() {
        baseView.addShadow(shadowColor: UIColor.black.withAlphaComponent(0.5).cgColor, shadowRadius: 5,
                           shadowOffset: CGSize(width: 0.5, height: 5), shadowOpacity: 1)
        baseView.layer.cornerRadius = 5
    }
    
    // MARK: - Public Interface
    func config(modelAvailableTurnDay: ModelAvailableTurnDay) {
        if let selected = modelAvailableTurnDay.selected {
            self.baseView.backgroundColor = selected ? .primary : .white
            dayLabel.labelTheme = RegularTheme(label: modelAvailableTurnDay.date?.toDisplayDay() ?? "", fontSize: 17,
                                               textColor: selected ? .white : .primary,
                                               textAlignment: .center)
            dateLabel.labelTheme = RegularTheme(label: modelAvailableTurnDay.date?.toDisplayableDate(type: .date) ?? "", fontSize: 17,
                                                textColor: selected ? .white : .primary,
                                                textAlignment: .center)
        }
    }
}

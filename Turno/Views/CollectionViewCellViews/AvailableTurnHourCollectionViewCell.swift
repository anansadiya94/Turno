//
//  AvailableTurnHourCollectionViewCell.swift
//  Turno
//
//  Created by Anan Sadiya on 09/08/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class AvailableTurnHourCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var hourLabel: CustomLabel!
    
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
    func config(emptySlot: EmptySlot) {
        self.baseView.backgroundColor = emptySlot.selected ? .primary : .white
        hourLabel.labelTheme = RegularTheme(label: emptySlot.dateTimeUTC?.toDisplayableDate(type: .hour) ?? "",
                                            fontSize: 17, textColor: emptySlot.selected ? .white : .primary, textAlignment: .center)
    }
}

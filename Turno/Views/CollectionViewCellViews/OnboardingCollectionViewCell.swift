//
//  OnboardingCollectionViewCell.swift
//  Turno
//
//  Created by Anan Sadiya on 03/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var subTitleLabel: CustomLabel!
    @IBOutlet weak var actionButton: RoundedCustomButton!
    
    private var amILast: Bool = false
    
    // MARK: - UICollectionViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.isUserInteractionEnabled = false
        setUpIBOutlets()
    }
    
    // MARK: - Private methods
    private func setUpIBOutlets() {
        setupActionButton()
    }
    
    private func setupActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func actionButtonTapped(sender: UIButton) {
        let idDataDict: [String: Bool] = ["amILast": amILast]
        NotificationCenter.default.post(name: OnBoarding.onBoardingButtonCellTapped, object: nil, userInfo: idDataDict)
    }
    
    // MARK: - Public Interface
    func setUp(modelOnboarding: ModelOnboarding) {
        self.amILast = modelOnboarding.amILast
        imageView.image = UIImage(named: modelOnboarding.backgroungImage)
        titleLabel.labelTheme = BoldTheme(label: modelOnboarding.title, fontSize: 30, textColor: .black, textAlignment: .center)
        subTitleLabel.labelTheme = RegularTheme(label: modelOnboarding.subTitle, fontSize: 15, textColor: .black, textAlignment: .center)
        actionButton.tag = modelOnboarding.id
        actionButton.buttonTheme = OnboardingTheme(label: modelOnboarding.actionTitle, isLast: modelOnboarding.amILast)
    }
}

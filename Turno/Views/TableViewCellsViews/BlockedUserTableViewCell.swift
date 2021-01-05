//
//  BlockedUserableViewCell.swift
//  Turno
//
//  Created by Anan Sadiya on 30/12/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Kingfisher

class BlockedUserTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var fullNameLabel: CustomLabel!
    @IBOutlet weak var phoneNumberLabel: CustomLabel!
    @IBOutlet weak var unblockButton: RoundedCustomButton!
    
    var userId: String?
    
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
        unblockButton.buttonTheme = RoundedBaseTheme(label: "Unblock", // TODO: Translate
                                                     backgroundColor: UIColor.black.withAlphaComponent(0.75))
    }
    
    // MARK: - UI interaction methods
    @IBAction func unblockButtonTapped(_ sender: Any) {
        if let userId = self.userId {
            let dict: [String: String] = ["userId": userId]
            NotificationCenter.default.post(name: BlockedUsers.unblockTapped, object: nil,
                                            userInfo: dict)
        }
    }

    // MARK: - Public Interface
    func config(userId: String?, fullName: String?, phoneNumber: String?) {
        self.userId = userId
        fullNameLabel.labelTheme = BoldTheme(label: fullName ?? "",
                                             fontSize: 20,
                                             textColor: .black,
                                             textAlignment: .left)
        phoneNumberLabel.labelTheme = RegularTheme(label: phoneNumber ?? "",
                                                   fontSize: 18,
                                                   textColor: .black,
                                                   textAlignment: .left)
    }
}

//
//  NoTurnsFoundTableViewCell.swift
//  Turno
//
//  Created by Anan Sadiya on 12/12/2021.
//  Copyright © 2021 Anan Sadiya. All rights reserved.
//

import UIKit

class NoTurnsFoundTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var messageLabel: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let titleText = LocalizedConstants.no_turns_error_title_key.localized
        let messageText = LocalizedConstants.no_turns_error_message_key.localized
        titleLabel.labelTheme = BoldTheme(label: titleText,
                                          fontSize: 20, textColor: .black,
                                          textAlignment: .center)
        messageLabel.labelTheme = RegularTheme(label: messageText,
                                               fontSize: 15, textColor: .black,
                                               textAlignment: .center)
    }
}

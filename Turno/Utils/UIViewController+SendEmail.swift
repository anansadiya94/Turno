//
//  UIViewController+SendEmail.swift
//  Turno
//
//  Created by Anan Sadiya on 22/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

extension UIViewController: MFMailComposeViewControllerDelegate {
    func sendEmail(_ email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject("Subject here")
            mail.setMessageBody("<p>Message here</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: LocalizedConstants.generic_error_title_key.localized,
                                          message: LocalizedConstants.generic_error_message_key.localized,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizedConstants.ok_key.localized,
                                          style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

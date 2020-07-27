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
            // TODO: SHOW ERROR ALERT?
            print("ERROR EMAIL ADDRESS")
        }
    }

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

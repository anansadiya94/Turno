//
//  ParentViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 08/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {

    var waitingView: LoadingViewController?
    private var isShownPopup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Prompts the waiting views and animation.
    func startWaiting(color: UIColor = .white) {
        DispatchQueue.main.async {
            if self.waitingView == nil {
                self.waitingView = LoadingViewController(containerView: self.view)
            }
            self.view.subviews.filter { $0.isKind(of: LoadingViewController.self) }
                .forEach { $0.removeFromSuperview() }
            self.waitingView?.start()
        }
    }
    
    /// Hides the waiting views and animation.
    func stopWaiting() {
        DispatchQueue.main.async {
            self.waitingView?.stop()
        }
    }
    
    /// Prompts a popup with the given title, text, button title and completion handler.
    /// - parameter title: String containing the title.
    /// - parameter text: String containing the text of the popup.
    /// - parameter button: String containing the button title.
    /// - parameter button2: String containing the second button title (if needed).
    /// - parameter completion: Callback.
    func showPopup(withTitle title: String?, withText text: String?, withButton button: String?, button2: String? = nil, completion: ((Bool) -> Void)?) {
        if !isShownPopup, presentedViewController == nil, UIApplication.shared.applicationState == .active {
            isShownPopup = true
            
            // Obscure background
            let alphaView = UIView(frame: self.view.frame)
            alphaView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
            alphaView.alpha = 1.0
            self.view.addSubview(alphaView)
            
            // Popup
            let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertController.Style.alert)
            
            // First action
            alert.addAction(UIAlertAction(title: button, style: .default, handler: { [weak self] _ in
                self?.view.subviews.last?.removeFromSuperview()
                self?.isShownPopup = false
                completion?(true)
            }))
            
            // Second Action
            if let button2 = button2 {
                alert.addAction(UIAlertAction(title: button2, style: .default, handler: { [weak self] _ in
                    self?.view.subviews.last?.removeFromSuperview()
                    self?.isShownPopup = false
                    completion?(true)
                }))
            }
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            debugPrint("There is still a popup ...")
        }
    }
}

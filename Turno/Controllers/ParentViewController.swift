//
//  ParentViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 08/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

protocol PresenterParentView: AnyObject {
    func startWaitingView()
    func stopWaitingView()
    func showPopupView(withTitle title: String?, withText text: String?, withButton button: String?, button2: String?, completion: ((Bool?, Bool?) -> Void)?)
    func showForceUpdatePopup()
    func showToast(message: String)
}

class ParentViewController: UIViewController {
    
    var waitingView: LoadingViewController?
    private var isShownPopup = false
    
    var navBarTitle: String {
        return ""
    }
    
    var isNavBarBackButtonHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.tintColor = .primary
        navigationItem.title = navBarTitle
        navigationItem.setHidesBackButton(isNavBarBackButtonHidden, animated: false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
    func showPopup(withTitle title: String?, withText text: String?, withButton button: String?, button2: String? = nil, completion: ((Bool?, Bool?) -> Void)?) {
        if !isShownPopup, presentedViewController == nil {
            isShownPopup = true
            
            // Obscure background
            let alphaView = UIView(frame: self.view.frame)
            alphaView.backgroundColor = .blackAlpha15
            alphaView.alpha = 1.0
            self.view.addSubview(alphaView)
            
            // Popup
            let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertController.Style.alert)
            
            // First action
            alert.addAction(UIAlertAction(title: button, style: .default, handler: { [weak self] _ in
                self?.view.subviews.last?.removeFromSuperview()
                self?.isShownPopup = false
                completion?(true, nil)
            }))
            
            // Second Action
            if let button2 = button2 {
                alert.addAction(UIAlertAction(title: button2, style: .default, handler: { [weak self] _ in
                    self?.view.subviews.last?.removeFromSuperview()
                    self?.isShownPopup = false
                    completion?(nil, true)
                }))
            }
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            debugPrint("There is still a popup ...")
        }
    }
    
    func showForceUpdatePopup() {
        stopWaiting()
        DispatchQueue.main.async {
            self.showPopup(withTitle: LocalizedConstants.force_update_title_key.localized,
                           withText: LocalizedConstants.force_update_message_key.localized,
                           withButton: LocalizedConstants.force_update_action_key.localized) { _, _ in
                if let url = URL(string: "itms-apps://apple.com/app/id1535076357") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    func showToast(message: String) {
        let toastLabel = CustomLabel()
        toastLabel.labelTheme = RegularTheme(label: "   \(message)   ", fontSize: 12.0, textColor: .white, textAlignment: .center)
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.backgroundColor = UIColor.primary
        
        guard let optionalWindow = UIApplication.shared.delegate?.window, let window = optionalWindow else { return }
        window.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            toastLabel.heightAnchor.constraint(equalToConstant: 40),
            toastLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90.0)
        ])
        
        UIView.animate(withDuration: 5.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {_ in
            toastLabel.removeFromSuperview()
        })
    }
}

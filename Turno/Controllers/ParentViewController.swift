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
}

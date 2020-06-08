//
//  LoadingViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 08/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {

    let containerView: UIView?
    let loadingAnimation = AnimationView(name: "loading")
    
    @IBOutlet weak var animationView: AnimationView!
    
    init(containerView: UIView? = nil) {
        self.containerView = containerView
        super.init(nibName: String(describing: LoadingViewController.self), bundle: nil)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnimationView()
    }
    
    private func setAnimationView() {
        animationView.contentMode = .scaleAspectFit
        self.animationView.addSubview(loadingAnimation)
        loadingAnimation.frame = self.animationView.bounds
        loadingAnimation.loopMode = .loop
    }
    
    func start() {
        if let container = containerView {
            container.addSubview(view)
            UIView.addConstraints(self.view, in: container)
        } else if view.superview == nil {
            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                view.frame = window.frame
                UIApplication.shared.windows.filter({$0.isKeyWindow}).first!.addSubview(view)
            }
        } else if animationView.isAnimationPlaying { return }
        UIView.transition(with: view, duration: 0.4, options: .transitionCrossDissolve, animations: { [weak self] in ()
            self?.animationView.alpha = 1.0
            self?.loadingAnimation.play()
            self?.view.alpha = 1.0
        }, completion: nil)
    }
    
    func stop() {
        if animationView == nil { return }
        if animationView.isAnimationPlaying {
            UIView.transition(with: view, duration: 0.4, options: .transitionCrossDissolve, animations: { [weak self] in
                self?.animationView.alpha = 0.0
                self?.animationView.stop()
                self?.view.alpha = 0.0
            }, completion: { [weak self] (_) in
                self?.view.removeFromSuperview()
            })
        }
    }
}

extension UIView {
    static func addConstraints(_ contentView: UIView, in containerView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints([
            NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: contentView,
                               attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: contentView,
                               attribute: .centerY, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: contentView,
                               attribute: .width, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: contentView,
                               attribute: .height, multiplier: 1.0, constant: 0.0)
        ])
    }
}

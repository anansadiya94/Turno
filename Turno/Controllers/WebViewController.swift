//
//  WebViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 11/04/2021.
//  Copyright © 2021 Anan Sadiya. All rights reserved.
//

import Foundation
import WebKit

enum WebViewType: String { // TOOD: Change the urls
    case about = "https://www.hackingwithswift.com/read/4/2/creating-a-simple-browser-with-wkwebview"
    case contactUs = "https://www.hackingwithswift.com/read/4/3/choosing-a-website-uialertcontroller-action-sheets"
    case termsOfUse = "https://www.hackingwithswift.com/read/4/4/monitoring-page-loads-uitoolbar-and-uiprogressview"
    
    var title: String {
        switch self {
        case .about: return LocalizedConstants.about_key.localized
        case .contactUs: return LocalizedConstants.contact_us_key.localized
        case .termsOfUse: return LocalizedConstants.terms_of_use_key.localized
        }
    }
}

class WebViewController: UIViewController, WKNavigationDelegate {
    
    private var webView: WKWebView!
    var webViewType: WebViewType?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = webViewType?.title
        guard let urlString = webViewType?.rawValue else { return }
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    // Used to close the pushed view with the present animation.
    @objc func closeView() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popViewController(animated: false)
    }
}

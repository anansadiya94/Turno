//
//  BusinessHomeViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 28/09/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class BusinessHomeViewController: ParentViewController {
    
    // MARK: - Properties
    override var navBarTitle: String {
        return "Business home"
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setNavigationBar()
    }
}

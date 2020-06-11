//
//  FavoritesViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class FavoritesViewController: ParentViewController {

    // MARK: - Properties
    override var navBarTitle: String {
        return LocalizedConstants.favorites_key.localized
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setNavigationBar()
    }
}

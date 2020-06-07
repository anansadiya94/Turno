//
//  ServiceViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

class ServiceViewController {
    
    static func instantiateViewControllerWithStoryBoard(sbName: String, vcID: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: sbName, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: vcID)
        return viewController
    }
}

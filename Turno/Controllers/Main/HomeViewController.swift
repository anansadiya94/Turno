//
//  HomeViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class HomeViewController: GenericTableView<HomeListDescriptive> {

    // MARK: - Properties
    override var navBarTitle: String {
        return LocalizedConstants.home_key.localized
    }
    
    var presenterHome: PresenterHome!
    @UseAutoLayout var homeView = HomeView()
    
    // MARK: - UIViewController
    init() {
        super.init(nibName: nil, bundle: nil)
        super.configureTableView(tableView: homeView.tableView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.configureTableView(tableView: homeView.tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(homeView)
        setHomeViewConstraints()
    }
    
    // MARK: - GenericTableView methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 216
    }
    
    // MARK: - Private methods
    private func setHomeViewConstraints() {
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            homeView.leftAnchor.constraint(equalTo: view.leftAnchor),
            homeView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

extension HomeViewController: PresenterHomeView {
    func didSetData(model: HomeListDescriptive) {
        self.source = model
        homeView.tableView.reloadData()
    }
    
    func startWaitingView() {
        startWaiting()
    }
    
    func stopWaitingView() {
        stopWaiting()
    }
    
    func showPopupView(withTitle title: String?, withText text: String?, withButton button: String?, button2: String?, completion: ((Bool?, Bool?) -> Void)?) {
        showPopup(withTitle: title, withText: text, withButton: button, button2: button2, completion: completion)
    }
}

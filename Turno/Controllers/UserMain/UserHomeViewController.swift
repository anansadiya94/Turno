//
//  HomeViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class UserHomeViewController: GenericTableView<GenericListDescriptive> {
    
    // MARK: - Properties
    override var navBarTitle: String {
        return LocalizedConstants.home_key.localized
    }
    
    var presenterHome: PresenterUserHome!
    @UseAutoLayout var genericView = GenericView()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(genericView)
        setGenericViewConstraints()
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenterHome.fetchData()
    }
    
    // MARK: - GenericTableView methods
    init() {
        super.init(nibName: nil, bundle: nil)
        super.configureTableView(tableView: genericView.tableView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.configureTableView(tableView: genericView.tableView)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 216
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenterHome.fetchData()
    }
    
    // MARK: - Private methods
    private func setGenericViewConstraints() {
        NSLayoutConstraint.activate([
            genericView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            genericView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
            genericView.leftAnchor.constraint(equalTo: view.leftAnchor),
            genericView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(cellTappedAction(_:)),
                                               name: GenericEntity.cellTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isFavoriteTappedAction(_:)),
                                               name: GenericEntity.isFavoriteTapped, object: nil)
    }
    
    // MARK: - UI interaction methods
    @objc func cellTappedAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let model = dict["model"] as? ModelBusiness {
                presenterHome.cellTapped(model: model)
            }
        }
    }
    
    @objc func isFavoriteTappedAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let identifier = dict["identifier"] as? String {
                presenterHome.isFavoriteTapped(entityIdentifier: identifier)
            }
        }
    }
}

// MARK: - PresenterUserHomeView methods
extension UserHomeViewController: PresenterUserHomeView {
    func didSetData(model: GenericListDescriptive) {
        self.source = model
        genericView.tableView.reloadData()
        refreshControl.endRefreshing()
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

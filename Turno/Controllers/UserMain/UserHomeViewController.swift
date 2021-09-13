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
        shouldForceUpdate()
        self.view.addSubview(genericView)
        setGenericViewConstraints()
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenterHome.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenterHome.trackScreen()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        if let model = source?.modelList[indexPath.row] {
            presenterHome.cellTapped(model: model)
        }
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenterHome.fetchData()
    }
    
    // MARK: - Private methods
    private func shouldForceUpdate() {
        if RemoteConfigManager.shouldForceUpdate() {
            showForceUpdatePopup()
        }
    }
    
    private func setGenericViewConstraints() {
        NSLayoutConstraint.activate([
            genericView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            genericView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
            genericView.leftAnchor.constraint(equalTo: view.leftAnchor),
            genericView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(isFavoriteTappedAction(_:)),
                                               name: GenericEntity.isFavoriteTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: - UI interaction methods
    @objc func isFavoriteTappedAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let identifier = dict["identifier"] as? String {
                presenterHome.isFavoriteTapped(entityIdentifier: identifier)
            }
        }
    }
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        shouldForceUpdate()
    }
}

// MARK: - PresenterUserHomeView methods
extension UserHomeViewController: PresenterUserHomeView {
    func didSetData(model: GenericListDescriptive) {
        self.source = model
        DispatchQueue.main.async {
            self.genericView.tableView.reloadData()
        }
        
    }
    
    func showEmptyMessage(title: String, message: String) {
        DispatchQueue.main.async {
            self.genericView.tableView.emptyMessage(title: title, message: message)
        }
    }
    
    func removeEmptyMessage() {
        DispatchQueue.main.async {
            self.genericView.tableView.removeEmptyMessage()
        }
    }
    
    func startWaitingView() {
        startWaiting()
    }
    
    func stopWaitingView() {
        stopWaiting()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.genericView.tableView.setContentOffset(.zero, animated: true)
        }
    }
    
    func showPopupView(withTitle title: String?, withText text: String?, withButton button: String?, button2: String?, completion: ((Bool?, Bool?) -> Void)?) {
        showPopup(withTitle: title, withText: text, withButton: button, button2: button2, completion: completion)
    }
}

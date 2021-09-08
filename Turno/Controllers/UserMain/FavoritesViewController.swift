//
//  FavoritesViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class FavoritesViewController: GenericTableView<GenericListDescriptive> {
    
    // MARK: - Properties
    override var navBarTitle: String {
        return LocalizedConstants.favorites_key.localized
    }
    
    var presenterFavorites: PresenterFavorites!
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
        presenterFavorites.fetchData()
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
            presenterFavorites.cellTapped(model: model)
        }
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenterFavorites.fetchData()
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
        NotificationCenter.default.addObserver(self, selector: #selector(isFavoriteTappedAction(_:)),
                                               name: GenericEntity.isFavoriteTapped, object: nil)
    }
    
    // MARK: - UI interaction methods
    @objc func isFavoriteTappedAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let identifier = dict["identifier"] as? String {
                presenterFavorites.isFavoriteTapped(entityIdentifier: identifier)
            }
        }
    }
}

// MARK: - PresenterFavoritesView methods
extension FavoritesViewController: PresenterFavoritesView {
    func didSetData(model: GenericListDescriptive) {
        self.source = model
        genericView.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func showEmptyMessage(title: String, message: String) {
        self.genericView.tableView.emptyMessage(title: title, message: message)
    }
    
    func removeEmptyMessage() {
        self.genericView.tableView.removeEmptyMessage()
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

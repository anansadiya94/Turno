//
//  BlockedUsersViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 30/12/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class BlockedUsersViewController: GenericTableView<BlockedUsersListDescriptive> {
    
    // MARK: - Properties
    override var navBarTitle: String {
        return "Blocked users"
    }
    
    var presenterBlockedUsers: PresenterBlockedUsers!
    @UseAutoLayout var genericView = GenericView()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        self.view.addSubview(genericView)
        setGenericViewConstraints()
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenterBlockedUsers.fetchData()
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
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenterBlockedUsers.fetchData()
    }
    
    // MARK: - Private methods
    override func setNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .primary
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain, target: self, action: #selector(addTappedAction))
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
        NotificationCenter.default.addObserver(self, selector: #selector(unblockTappedAction(_:)),
                                               name: BlockedUsers.unblockTapped, object: nil)
    }
    
    // MARK: - UI interaction methods
    @objc func addTappedAction() {
        presenterBlockedUsers.addTapped()
    }
    
    @objc func unblockTappedAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let userId = dict["userId"] as? String {
                presenterBlockedUsers.unblockTapped(userId: userId)
            }
        }
    }
}

// MARK: - PresenterBlockedUsersView methods
extension BlockedUsersViewController: PresenterBlockedUsersView {
    func didSetData(model: BlockedUsersListDescriptive) {
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
    
    func addTapped(title: String, message: String) {
        // Obscure background
        let alphaView = UIView(frame: self.view.frame)
        alphaView.backgroundColor = .blackAlpha15
        alphaView.alpha = 1.0
        self.view.addSubview(alphaView)
        
        // Popup
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // First action
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak self] _ in
            self?.view.subviews.last?.removeFromSuperview()
        }))
        
        var textField = UITextField()
        // Second Action
        alert.addAction(UIAlertAction(title: "Block", style: .default, handler: { [weak self] _ in
            self?.view.subviews.last?.removeFromSuperview()
            self?.presenterBlockedUsers.blockUser(phoneNumber: textField.text!)
        }))
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter phone number"
            alertTextField.keyboardType = .phonePad
            textField = alertTextField
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

//
//  SettingsViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

enum SettingsRows {
    case blockedUsers
    case notifications
    case about
    case contactUs
    case share
    case termsOfUse
    case changeToBusiness
    case changeToUser
    
    var image: String {
        switch self {
        case .blockedUsers: return "lock"
        case .notifications: return "bell.fill"
        case .about: return "info"
        case .contactUs: return "lock"
        case .share: return "square.and.arrow.up"
        case .termsOfUse: return "lock"
        case .changeToBusiness: return "building.2"
        case .changeToUser: return "person"
        }
    }
    
    var text: String {
        switch self {
        case .blockedUsers: return LocalizedConstants.blocked_users_key.localized
        case .notifications: return LocalizedConstants.notifications_key.localized
        case .about: return LocalizedConstants.about_key.localized
        case .contactUs: return LocalizedConstants.contact_us_key.localized
        case .share: return LocalizedConstants.share_key.localized
        case .termsOfUse: return LocalizedConstants.terms_of_use_key.localized
        case .changeToBusiness: return LocalizedConstants.change_to_business_key.localized
        case .changeToUser: return LocalizedConstants.change_to_user_key.localized
        }
    }
}

class SettingsViewController: ParentViewController {
    
    // MARK: - Properties
    override var navBarTitle: String {
        return LocalizedConstants.settings_key.localized
    }
    
    var presenterSettings: PresenterSettings!
    @UseAutoLayout var genericView = GenericView()
    private var settingsRows: [[SettingsRows]] = [[]]
    let headerTitles = [LocalizedConstants.app_key.localized,
                        LocalizedConstants.business_key.localized]
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setGenericView()
        setTableView()
        setRows()
    }
    
    // MARK: - Private methods
    private func setGenericView() {
        self.view.addSubview(genericView)
        NSLayoutConstraint.activate([
            genericView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            genericView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            genericView.leftAnchor.constraint(equalTo: view.leftAnchor),
            genericView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setTableView() {
        genericView.tableView.dataSource = self
        genericView.tableView.delegate = self
        genericView.tableView.register(UINib(nibName: kServiceTableViewCellNib, bundle: nil),
                                       forCellReuseIdentifier: kServiceCellID)
        genericView.tableView.tableFooterView = UIView()
    }
    
    private func setRows() {
        let appSettingRows: [SettingsRows] = [
            .notifications,
            .about,
            .contactUs,
            .share,
            .termsOfUse
        ]
        var businessSettingRows: [SettingsRows] = []
        if Preferences.isBusiness() {
            if AppData.isBusiness {
                businessSettingRows = [.changeToUser, .blockedUsers]
            } else {
                businessSettingRows = [.changeToBusiness]
            }
            
        }
        if businessSettingRows.isEmpty {
            settingsRows = [appSettingRows]
        } else {
            settingsRows = [appSettingRows, businessSettingRows]
        }
    }
}

// MARK: - UITableViewDataSource methods
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsRows.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsRows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.tintColor = .black
        cell.imageView?.image = UIImage(systemName: settingsRows[indexPath.section][indexPath.row].image)
        cell.textLabel?.text = settingsRows[indexPath.section][indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
}

// MARK: - UITableViewDelegate methods
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenterSettings.trackSettingsRow(settingsRows[indexPath.section][indexPath.row].text)
        switch settingsRows[indexPath.section][indexPath.row] {
        case .changeToUser:
            presenterSettings.changeToUser()
        case .changeToBusiness:
            presenterSettings.changeToBusiness()
        case .share:
            presenterSettings.share()
        case .notifications:
            presenterSettings.notifications()
        case .blockedUsers:
            presenterSettings.blockedUsers()
        case .about:
            presenterSettings.openWebView(for: .about)
        case .contactUs:
            presenterSettings.openWebView(for: .contactUs)
        case .termsOfUse:
            presenterSettings.openWebView(for: .termsOfUse)
        }
    }
}

extension SettingsViewController: PresenterSettingsView {
    func startWaitingView() {
        startWaiting()
    }
    
    func stopWaitingView() {
        stopWaiting()
    }
    
    func showPopupView(withTitle title: String?, withText text: String?, withButton button: String?, button2: String?, completion: ((Bool?, Bool?) -> Void)?) {
        showPopup(withTitle: title, withText: text, withButton: button, button2: button2, completion: completion)
    }
    
    func share() {
        if let appUrl = URL(string: "https://apps.apple.com/es/app/affinity-publisher/id881418622?l=en&mt=12") {
            let activityViewController = UIActivityViewController(activityItems: [appUrl], applicationActivities: nil)
            present(activityViewController, animated: true)
        }
    }
}

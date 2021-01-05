//
//  SettingsViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 07/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

enum SettingsRows {
    case editProfile
    case businessConfiguration
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
        case .editProfile: return "pencil"
        case .businessConfiguration: return "slider.vertical.3"
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
        case .editProfile: return "Edit Profile"
        case .businessConfiguration: return "Business Configuration"
        case .blockedUsers: return "Blocked Users"
        case .notifications: return "Notifications"
        case .about: return "About"
        case .contactUs: return "Contact Us"
        case .share: return "Share"
        case .termsOfUse: return "Terms Of Use"
        case .changeToBusiness: return "Change To Business"
        case .changeToUser: return "Change To User"
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
    let headerTitles = ["Account", "App", "Business"]
    
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
        let accountSettingRows: [SettingsRows] = [
            .editProfile,
            .businessConfiguration,
            .blockedUsers
        ]
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
                businessSettingRows = [.changeToUser]
            } else {
                businessSettingRows = [.changeToBusiness]
            }
            
        }
        if businessSettingRows.isEmpty {
            settingsRows = [accountSettingRows, appSettingRows]
        } else {
            settingsRows = [accountSettingRows, appSettingRows, businessSettingRows]
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
        default:
            break
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

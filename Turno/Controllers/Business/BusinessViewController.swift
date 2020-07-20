//
//  BusinessViewController.swift
//  Turno
//
//  Created by Anan Sadiya on 18/07/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import UIKit

class BusinessViewController: ParentViewController {
    
    // MARK: - Properties
    var presenterBusiness: PresenterBusiness!
    @UseAutoLayout var businessView = BusinessView()
    
    var model: ModelBusiness?
    var services: [Service]?
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setBusinessViewConstraints()
        setTableView()
        setTableView()
        addTarget()
        addObserver()
    }
    
    // MARK: - Private methods
    private func setBusinessViewConstraints() {
        self.view.addSubview(businessView)
        NSLayoutConstraint.activate([
            businessView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            businessView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            businessView.leftAnchor.constraint(equalTo: view.leftAnchor),
            businessView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setTableView() {
        businessView.tableView.dataSource = self
        businessView.tableView.register(UINib(nibName: kServiceTableViewCellNib, bundle: nil),
                                        forCellReuseIdentifier: kServiceCellID)
    }
    
    private func addTarget() {
        businessView.segmentedControl.addTarget(self, action: #selector(handleSegmentControl), for: .valueChanged)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(modifyModelAction(_:)),
                                               name: Business.modifyModel, object: nil)
    }
    
    // MARK: - UI interaction methods
    @objc func modifyModelAction(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let model = dict["model"] as? ModelModifyService {
                presenterBusiness.modifyModel(identifier: model.identifier, count: model.count)
            }
        }
    }
    
    private func serviceCell(_ indexPath: IndexPath) -> UITableViewCell {
        if let cell = businessView.tableView.dequeueReusableCell(withIdentifier: kServiceCellID, for: indexPath) as? ServiceTableViewCell,
            let service = services?[indexPath.row] {
            cell.config(service: service)
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - UI interaction methods
    @objc private func handleSegmentControl() {
        businessView.tableView.reloadData()
    }
}

// MARK: - PresenterBusinessView methods
extension BusinessViewController: PresenterBusinessView {
    func didSetData(model: ModelBusiness) {
        self.model = model

        guard let servicesInit = model.services else { return }
        for index in 0..<servicesInit.count {
            servicesInit[index].count = 0
        }
        self.services = servicesInit
        
        DispatchQueue.main.async {
            self.navigationItem.title = model.name
            self.businessView.setImage(image: model.image)
            self.businessView.tableView.reloadData()
        }
    }
    
    func modifyModel(identifier: String, count: Int) {
        services?.first(where: { $0.identifier == identifier })?.count = count
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

// MARK: - UITableViewDataSource methods
extension BusinessViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch businessView.segmentedControl.selectedSegmentIndex {
        case 0:
            return services?.count ?? 0
        case 1:
            return model?.turns?.count ?? 0
        case 2:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch businessView.segmentedControl.selectedSegmentIndex {
        case 0:
            return serviceCell(indexPath)
        case 1:
            return UITableViewCell()
        case 2:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

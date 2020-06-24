//
//  GenericTableView.swift
//  Turno
//
//  Created by Anan Sadiya on 24/06/2020.
//  Copyright © 2020 Anan Sadiya. All rights reserved.
//

import Foundation
import UIKit

class GenericTableView<T: DescriptiveProtocol>: ParentViewController, UITableViewDelegate, UITableViewDataSource {

    public var tableView =  UITableView()
    public var source: T? {
        willSet {
            for sectionDescriptor in newValue!.sectionDescriptor {
                for descriptor in sectionDescriptor.descriptors {
                    tableView.register(UINib(nibName: descriptor.reuseIdentifier, bundle: nil),
                                       forCellReuseIdentifier: descriptor.reuseIdentifier)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        setTableViewSeparator()
    }
    
    public func setTableViewSeparator() {
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
    }

    public func needsPagination() {
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
    }

    public func configureTableView(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        source?.sectionDescriptor[section].descriptors.count ?? 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let descriptor = source?.sectionDescriptor[indexPath.section].descriptors[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: descriptor.reuseIdentifier, for: indexPath)
            descriptor.configure(cell)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let descriptor = source?.sectionDescriptor[indexPath.section].descriptors[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        descriptor!.didSelect(cell!)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return source?.sectionDescriptor.count ?? 1
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = UIColor.black
        header?.textLabel?.font = Fonts.Regular12
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

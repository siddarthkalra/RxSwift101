//
//  MenuItemPickerViewController.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2019-01-02.
//  Copyright © 2019 Siddarth Kalra. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MenuItemPickerViewController: UITableViewController {

    private let viewModel: MenuItemPickerViewModel

    required init(viewModel: MenuItemPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCellID")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "menuItemCellID")
        }

        let menuItem = viewModel.menuItem(forIndexPath: indexPath)
        cell?.textLabel?.text = menuItem.0
        cell?.detailTextLabel?.text = "$\(menuItem.1)"
        
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectMenuItem(atIndexPath: indexPath)
    }
}

class MenuItemPickerViewModel {

    let menuItems: [MenuItem] = [("Eggs", 1.5), ("Waffles", 2.5), ("Pancakes", 3), ("Crepes", 5)]
    private let menuItemRelay = PublishRelay<MenuItem>()

    private (set) lazy var menuItemDriver = menuItemRelay.asDriver { _ in assertionFailure(); return .never() }

    let disposeBag = DisposeBag()

    var rows: Int {
        return menuItems.count
    }

    func menuItem(forIndexPath indexPath: IndexPath) -> MenuItem {
        return menuItems[indexPath.row]
    }

    func selectMenuItem(atIndexPath indexPath: IndexPath) {
        let currentMenuItem = menuItem(forIndexPath: indexPath)
        menuItemRelay.accept(currentMenuItem)
    }
}

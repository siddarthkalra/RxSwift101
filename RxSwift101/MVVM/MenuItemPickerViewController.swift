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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuItemCellID")
        tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCellID", for: indexPath)
        cell.textLabel?.text = viewModel.menuItem(forIndexPath: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectMenuItem(atIndexPath: indexPath)
    }
}

class MenuItemPickerViewModel {

    let menuItems: [MenuItem] = ["Eggs", "Waffles", "Pancakes", "Crepes"]
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

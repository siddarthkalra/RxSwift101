//
//  OrderCartViewController.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2019-01-02.
//  Copyright © 2019 Siddarth Kalra. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderCartViewController: UITableViewController {

    private let viewModel: OrderCartViewModel

    required init(viewModel: OrderCartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "orderItemCellID")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1)

        setupBindings()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderItemCellID", for: indexPath)
        cell.textLabel?.text = viewModel.orderItemName(forIndexPath: indexPath)
        cell.backgroundColor = tableView.backgroundColor

        return cell
    }
}

private extension OrderCartViewController {

    func setupBindings() {
        viewModel.orderItemDriver
            .skip(1)
            .drive(onNext: { [unowned self] orderItem in
                self.viewModel.orderItems.append(orderItem)
                self.tableView.reloadData()
            }).disposed(by: viewModel.disposeBag)
    }

}

class OrderCartViewModel {

    let disposeBag = DisposeBag()

    let orderItemRelay = BehaviorRelay<String>(value: "")
    private (set) lazy var orderItemDriver = orderItemRelay.asDriver()

    var orderItems = [String]()

    var rows: Int {
        return orderItems.count
    }

    func orderItemName(forIndexPath indexPath: IndexPath) -> String {
        return orderItems[indexPath.row]
    }
}

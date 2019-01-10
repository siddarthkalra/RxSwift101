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
    private var orderItems = [OrderItem]()

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
        return rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderItemCellID", for: indexPath)
        cell.textLabel?.text = orderItem(forIndexPath: indexPath)
        cell.backgroundColor = tableView.backgroundColor

        return cell
    }
}

private extension OrderCartViewController {

    var rows: Int {
        return orderItems.count
    }

    func orderItem(forIndexPath indexPath: IndexPath) -> OrderItem {
        return orderItems[indexPath.row]
    }

    func setupBindings() {
        viewModel.orderItemsDriver
            .drive(onNext: { [unowned self] orderItems in
                self.orderItems = orderItems
                self.tableView.reloadData()
            }).disposed(by: viewModel.disposeBag)
    }

}

class OrderCartViewModel {

    let disposeBag = DisposeBag()
    let newMenuItemRelay = BehaviorRelay<MenuItem>(value: "")

    private let orderItemsRelay = BehaviorRelay<[OrderItem]>(value: [])
    private (set) lazy var orderItemsDriver = orderItemsRelay.asDriver()

    init() {
        newMenuItemRelay
            .skip(1)
            .withLatestFrom(orderItemsRelay, resultSelector: handleNewItems)
            .bind(to: orderItemsRelay)
            .disposed(by: disposeBag)
    }

    private var handleNewItems: (MenuItem, [OrderItem]) -> [OrderItem] = { newMenuItem, oldOrderItems in
        return oldOrderItems + [newMenuItem]
    }
}

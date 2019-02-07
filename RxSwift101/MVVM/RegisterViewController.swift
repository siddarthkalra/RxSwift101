//
//  RegisterViewController.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2019-01-01.
//  Copyright © 2019 Siddarth Kalra. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

typealias MenuItem = (String, Decimal)
typealias OrderItem = (String, Decimal)

class RegisterViewController: UIViewController {

    @IBOutlet weak var menuItemPickerView: UIView!
    @IBOutlet weak var orderCartView: UIView!
    @IBOutlet weak var orderCartSummaryView: UIView!
    
    private let viewModel: RegisterViewModel

    required init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        setupChildVCs()
    }

}

private extension RegisterViewController {

    func setupChildVCs() {
        let menuItemPickerViewModel = MenuItemPickerViewModel()
        let orderCartViewModel = OrderCartViewModel()
        let orderCartSummaryViewModel = OrderCartSummaryViewModel()
        
        // setup databinding
        menuItemPickerViewModel.menuItemDriver
            .drive(orderCartViewModel.newMenuItemRelay)
            .disposed(by: menuItemPickerViewModel.disposeBag)

        menuItemPickerViewModel.menuItemDriver
            .map { $0.1 } // get the price
            .drive(orderCartSummaryViewModel.newValueRelay)
            .disposed(by: menuItemPickerViewModel.disposeBag)
        
        let menuItemPickerVC = MenuItemPickerViewController(viewModel: menuItemPickerViewModel)
        let orderCartVC = OrderCartViewController(viewModel: orderCartViewModel)
        let orderCartSummaryVC = OrderCartSummaryViewController(viewModel: orderCartSummaryViewModel)

        addChild(menuItemPickerVC, toSubview: menuItemPickerView)
        addChild(orderCartVC, toSubview: orderCartView)
        addChild(orderCartSummaryVC, toSubview: orderCartSummaryView)
    }

}

class RegisterViewModel {

}

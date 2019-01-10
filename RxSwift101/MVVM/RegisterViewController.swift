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

typealias MenuItem = String
typealias OrderItem = String

class RegisterViewController: UIViewController {

    @IBOutlet weak var menuItemPickerView: UIView!
    @IBOutlet weak var orderCartView: UIView!

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

        // setup databinding
        menuItemPickerViewModel.menuItemDriver
            .drive(orderCartViewModel.newMenuItemRelay)
            .disposed(by: menuItemPickerViewModel.disposeBag)

        let menuItemPickerVC = MenuItemPickerViewController(viewModel: menuItemPickerViewModel)
        let orderCartVC = OrderCartViewController(viewModel: orderCartViewModel)

        addChild(menuItemPickerVC, toSubview: menuItemPickerView, useSafeArea: false)
        addChild(orderCartVC, toSubview: orderCartView, useSafeArea: false)
    }

}

class RegisterViewModel {

}

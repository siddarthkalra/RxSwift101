//
//  MainViewController.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2019-01-02.
//  Copyright © 2019 Siddarth Kalra. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    enum Data: String, CaseIterable, CustomStringConvertible {
        case mvvm = "MVVM"
        case observables = "Observables"
        case tapSequence = "Tap Sequence"
        case colorSequence = "Color Sequence"

        var viewController: UIViewController {
            switch self {
            case .mvvm:
                let viewModel = RegisterViewModel()
                return RegisterViewController.init(viewModel: viewModel)
            case .observables:
                return RxExamplesViewController(style: .grouped)
            case .tapSequence:
                return TapSequenceViewController()
            case .colorSequence:
                return ColorSequenceViewController()
            }
        }

        var description: String {
            return rawValue
        }
    }

    let data = Data.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RxSwift 101"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mainCellID")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCellID", for: indexPath)

        cell.textLabel?.text = String(describing: data[indexPath.row])
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = data[indexPath.row].viewController
        navigationController?.pushViewController(vc, animated: true)
    }

}

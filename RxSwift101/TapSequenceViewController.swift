//
//  TapSequenceViewController.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2019-01-09.
//  Copyright © 2019 Siddarth Kalra. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TapSequenceViewController: UIViewController {

    private var button: UIButton!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tap Sequence"
        view.backgroundColor = .white

        setupButton()

        button.rx.tap.subscribe(onNext: { _ in
            print("rx tapped")
        }).disposed(by: disposeBag)
    }

}

private extension TapSequenceViewController {

    func setupButton() {
        button = UIButton(type: .system)
        button.setTitle("Tap me", for: .normal)
        button.backgroundColor = .green

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        view.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}

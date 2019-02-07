//
//  OrderCartSummaryViewController.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2019-02-05.
//  Copyright © 2019 Siddarth Kalra. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderCartSummaryViewController: UIViewController {
    
    private let viewModel: OrderCartSummaryViewModel
    private let totalsValueLabel = UILabel()
    
    required init(viewModel: OrderCartSummaryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupBindings()
    }
    
}

private extension OrderCartSummaryViewController {
    
    func setupViews() {
        let totalsLabel = UILabel()
        totalsLabel.text = "Totals:"
        totalsValueLabel.text = "0.0"
        
        let horizontalStackView = UIStackView(arrangedSubviews: [totalsLabel, totalsValueLabel])
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            horizontalStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupBindings() {
        viewModel.totalsRelay
            .map( { "\($0)" })
            .bind(to: totalsValueLabel.rx.text)
            .disposed(by: viewModel.disposeBag)
    }
    
}

class OrderCartSummaryViewModel {
    
    let disposeBag = DisposeBag()
    let newValueRelay = BehaviorRelay<Decimal>(value: 0)
    let totalsRelay = BehaviorRelay<Decimal>(value: 0)
    
    init() {
        newValueRelay
            .skip(1)
            .withLatestFrom(totalsRelay, resultSelector: handleNewValues)
            .bind(to: totalsRelay)
            .disposed(by: disposeBag)
    }
    
    private var handleNewValues: (Decimal, Decimal) -> Decimal = { newValue, oldTotal in
        return oldTotal + newValue
    }
    
}

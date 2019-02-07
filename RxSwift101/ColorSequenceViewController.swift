//
//  ColorSequenceViewController.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2019-01-09.
//  Copyright © 2019 Siddarth Kalra. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ColorSequenceViewController: UIViewController {

    private var colorView: UIView!
    private var textField1: UITextField!
    private var textField2: UITextField!
    private var textField3: UITextField!

    let disposeBag = DisposeBag()

    func uiColorTransform(data: (String, String, String)) -> UIColor {
        let red = Int(data.0) ?? 0
        let green = Int(data.1) ?? 0
        let blue = Int(data.2) ?? 0

        return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Color Sequence"
        view.backgroundColor = .white

        setupViews()

        Observable
            .combineLatest(textField1.rx.text.filterNil(), textField2.rx.text.filterNil(), textField3.rx.text.filterNil())
            .map(uiColorTransform)
            .bind(to: colorView.rx.backgroundColor)
            .disposed(by: disposeBag)
    }

}

private extension ColorSequenceViewController {

    func setupViews() {
        textField1 = UITextField()
        textField1.placeholder = "Red"
        textField1.borderStyle = .roundedRect

        textField2 = UITextField()
        textField2.placeholder = "Green"
        textField2.borderStyle = .roundedRect

        textField3 = UITextField()
        textField3.placeholder = "Blue"
        textField3.borderStyle = .roundedRect

        let stackView = UIStackView(arrangedSubviews: [textField1, textField2, textField3])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        view.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        colorView = UIView()
        colorView.backgroundColor = .clear
        colorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorView)

        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -10).isActive = true
        view.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: -10).isActive = true
        view.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: colorView.rightAnchor, constant: 10).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

}

extension ObservableType where E: OptionalType {

    func filterNil() -> Observable<E.Wrapped> {
        return flatMap { Observable.from(optional: $0.asOptional) }
    }

}

extension Reactive where Base: UIView {

    var backgroundColor: Binder<UIColor?> {
        return Binder(base) { view, attr in
            UIView.animate(withDuration: 0.3) {
                view.backgroundColor = attr
            }
        }
    }

}

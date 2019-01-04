//
//  ObservableSequenceController.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2018-12-05.
//  Copyright © 2018 Siddarth Kalra. All rights reserved.
//

import UIKit
import RxSwift

class ObservableSequenceController: UIViewController {

    let disposeBag = DisposeBag()
    var rxExample: RxExample!
    var lastIndex: Int = 0
    var errorOcurred = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        title = String(describing: rxExample!)
        setupMainObservable()
    }

}

private extension ObservableSequenceController {

    func setupMainObservable()  {
        getMainObservable()
            .subscribe { [unowned self] event in
                switch event {
                case .next(let datum):
                    let color: UIColor = datum.element == "ERR" ? .red : .blue
                    if datum.element == "ERR" {
                        self.errorOcurred = true
                    }

                    self.makeViewWithName(datum.element, atIndex: datum.index, color: color)
                    self.lastIndex = datum.index
                case .error(let error):
                    self.errorOcurred = true
                    self.makeViewWithName(error.localizedDescription, atIndex: self.lastIndex + 1, color: .red)
                case .completed:
                    if self.errorOcurred {
                        return
                    }

                    self.makeViewWithName("COM", atIndex: self.lastIndex + 1, textColor: .black, color: .green)
                }

            }.disposed(by: disposeBag)
    }

    func getMainObservable() -> Observable<(index: Int, element: String)> {
        let exampleClosure = RxExampleFactory.exampleClosure(forExample: rxExample)
        let observ: Observable<String> = exampleClosure()

        let delay = Observable<Int>.interval(1.5, scheduler: MainScheduler.instance)
        let mainObservable = observ.catchErrorJustReturn("ERR")

        return Observable
            .zip(delay, mainObservable) { $1 }
            .enumerated()
    }

}

private extension ObservableSequenceController {

    func makeViewWithName(_ name: String, atIndex index: Int, textColor: UIColor = .white, color: UIColor = .blue) {
        let yPos: CGFloat = 100
        let superViewWidth = view.frame.size.width
        let viewSize = CGSize(width: 40, height: 40)
        let startFrame = CGRect(x: superViewWidth, y: yPos, width: viewSize.width, height: viewSize.height)

        let smallSquare = UIView(frame: startFrame)
        smallSquare.backgroundColor = color
        view.addSubview(smallSquare)

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
        label.text = name
        label.textColor = textColor
        label.textAlignment = .center
        smallSquare.addSubview(label)

        let padding: CGFloat = 5
        let xPosDelta = (viewSize.width + padding) * CGFloat(index)
        smallSquare.animateTo(frame: CGRect(x: padding + xPosDelta, y: yPos, width: viewSize.width, height: viewSize.height), withDuration: 1.5)
    }

}


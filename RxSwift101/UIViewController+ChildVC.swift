//
//  UIViewController+ChildVC.swift
//  RxSwift101
//
//  Created by Siddarth Kalra on 2019-01-02.
//  Copyright © 2019 Siddarth Kalra. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChild(_ vc: UIViewController, toSubview: UIView, belowView: UIView? = nil, useSafeArea: Bool = true) {
        addChild(vc)
        vc.didMove(toParent: self)

        defer {
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            if useSafeArea {
                vc.view.topAnchor.constraint(equalTo: toSubview.safeAreaLayoutGuide.topAnchor).isActive = true
                vc.view.bottomAnchor.constraint(equalTo: toSubview.safeAreaLayoutGuide.bottomAnchor).isActive = true
                vc.view.leftAnchor.constraint(equalTo: toSubview.safeAreaLayoutGuide.leftAnchor).isActive = true
                vc.view.rightAnchor.constraint(equalTo: toSubview.safeAreaLayoutGuide.rightAnchor).isActive = true
            } else {
                vc.view.topAnchor.constraint(equalTo: toSubview.topAnchor).isActive = true
                vc.view.bottomAnchor.constraint(equalTo: toSubview.bottomAnchor).isActive = true
                vc.view.leftAnchor.constraint(equalTo: toSubview.leftAnchor).isActive = true
                vc.view.rightAnchor.constraint(equalTo: toSubview.rightAnchor).isActive = true
            }
        }

        guard let belowView = belowView else {
            toSubview.addSubview(vc.view)
            return
        }

        toSubview.insertSubview(vc.view, belowSubview: belowView)
    }
}

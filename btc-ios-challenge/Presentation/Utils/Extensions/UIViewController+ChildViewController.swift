//
//  UIViewController+ChildViewController.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 28/09/23.
//

import UIKit

extension UIViewController {
    func add(_ childController: UIViewController,
             with animations: (() -> Void)? = nil,
             duration: TimeInterval? = nil
    ) {
        view.addSubview(childController.view)
        addChild(childController)
        
        if let animations = animations, let duration = duration {
            UIView.animate(withDuration: duration,
                           animations: animations) {_ in
                childController.didMove(toParent: self)
            }
        } else {
            childController.didMove(toParent: self)
        }
    }
}

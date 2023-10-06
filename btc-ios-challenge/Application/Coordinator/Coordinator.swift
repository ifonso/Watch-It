//
//  Coordinator.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 27/09/23.
//

import UIKit

enum Events {
    case movieTapped(MovieResponse)
}

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
    func sendScreenEvent(with: Events)
}

protocol Coordinating where Self: UIViewController {
    var coordinator: Coordinator? { get set }
}

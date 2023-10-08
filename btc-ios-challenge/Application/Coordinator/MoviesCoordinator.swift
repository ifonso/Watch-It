//
//  MoviesCoordinator.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 05/10/23.
//

import Foundation
import UIKit

final class MoviesCoordinator: Coordinator {
    
    init(provider: ViewControllerProvider, rootNavigator: UINavigationController) {
        self.viewControllerProvider = provider
        self.navigationController = rootNavigator
    }
    
    var navigationController: UINavigationController
    let viewControllerProvider: ViewControllerProvider
    
    func start() {
        let rootViewController = viewControllerProvider.getMoviesViewController(coordinator: self)
        self.navigationController.viewControllers = [rootViewController]
    }
    
    func sendScreenEvent(with event: Events) {
        if case .movieTapped(let movie) = event {
            pushMovieDetails(with: movie)
        }
    }
    
    private func pushMovieDetails(with movie: MovieResponse) {
        let movieDetailsViewController = viewControllerProvider.getMovieDetailsController(movie: movie)
        self.navigationController.pushViewController(movieDetailsViewController, animated: true)
    }
}

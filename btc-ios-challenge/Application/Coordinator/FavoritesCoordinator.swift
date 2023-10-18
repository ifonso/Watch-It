//
//  FavoritesCoordinator.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 17/10/23.
//

import Foundation
import UIKit

final class FavoritesCoordinator: Coordinator {
    
    init(provider: ViewControllerProvider, rootNavigator: UINavigationController) {
        self.viewControllerProvider = provider
        self.navigationController = rootNavigator
    }
    
    var navigationController: UINavigationController
    let viewControllerProvider: ViewControllerProvider
    
    func start() {
        let rootViewController = viewControllerProvider.getFavoriteMoviesViewController(coordinator: self)
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


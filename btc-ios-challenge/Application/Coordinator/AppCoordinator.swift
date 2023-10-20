//
//  AppCoordinator.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 19/10/23.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let viewControllerProvider: ViewControllerProvider
    
    private var moviesNavigator: UINavigationController = UINavigationController()
    private var favoritesNavigator: UINavigationController = UINavigationController()
    private var tabBarController: UITabBarController = UITabBarController()
    
    init(window: UIWindow, provider: ViewControllerProvider) {
        self.window = window
        self.viewControllerProvider = provider
    }
    
    func start() {
        let moviesViewController = viewControllerProvider.getMoviesViewController(coordinator: self)
        moviesNavigator.viewControllers = [moviesViewController]
        moviesNavigator.navigationBar.prefersLargeTitles = false
        moviesNavigator.tabBarItem = UITabBarItem(title: "Filmes",
                                                  image: UIImage(systemName: "popcorn"),
                                                  tag: 1)
        
        let favoritesViewController = viewControllerProvider.getFavoriteMoviesViewController(coordinator: self)
        favoritesNavigator.viewControllers = [favoritesViewController]
        favoritesNavigator.navigationBar.prefersLargeTitles = false
        favoritesNavigator.tabBarItem = UITabBarItem(title: "Favoritos",
                                                     image: UIImage(systemName: "star.fill"),
                                                     tag: 2)
        
        tabBarController.setViewControllers([moviesNavigator, favoritesNavigator], animated: false)
        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.unselectedItemTintColor = .gray
        
        window.rootViewController = tabBarController
    }
    
    func sendScreenEvent(with event: Events, _ sender: UIViewController) {
        if case .movieTapped(let movie) = event {
            pushMovieDetails(with: movie, sender: sender)
        }
    }
    
    private func pushMovieDetails(with movie: MovieResponse, sender: UIViewController) {
        let movieDetailsViewController = viewControllerProvider.getMovieDetailsController(movie: movie)
        if sender is MoviesTableViewController {
            self.moviesNavigator.pushViewController(movieDetailsViewController, animated: true)
        } else if sender is FavoritesTableViewController {
            self.favoritesNavigator.pushViewController(movieDetailsViewController, animated: true)
        }
    }
}

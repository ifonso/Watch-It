//
//  TabBarController.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 27/09/23.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Fix unecessary coordinators
        
        let defaultNetworkManager = NetworkManager()
        let viewControllerProvider = ViewControllerProvider(network: defaultNetworkManager)

        // MARK: - Filmes tab
        let moviesNavigationController = UINavigationController()
        
        moviesNavigationController.navigationBar.prefersLargeTitles = false
        moviesNavigationController.tabBarItem = UITabBarItem(title: "Filmes",
                                                             image: UIImage(systemName: "popcorn"),
                                                             tag: 1)
        
        let moviesCoordinator = MoviesCoordinator(provider: viewControllerProvider,
                                                  rootNavigator: moviesNavigationController)
        moviesCoordinator.start()
        
        // MARK: - Favoritos tab
        let favoritesNavigationController = UINavigationController()
        
        favoritesNavigationController.navigationBar.prefersLargeTitles = false
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "Favoritos",
                                                                image: UIImage(systemName: "star.fill"),
                                                                tag: 2)
        
        let favoritesCoordinator = FavoritesCoordinator(provider: viewControllerProvider,
                                                        rootNavigator: favoritesNavigationController)
        favoritesCoordinator.start()
        
        // MARK: - config tab bar
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.isTranslucent = true
        self.setViewControllers([moviesNavigationController, favoritesNavigationController],
                                animated: false)
    }
}

//
//  ViewControllerProvider.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 27/09/23.
//

import Foundation
import UIKit

final class ViewControllerProvider {
    
    private let network: NetworkManagerProtocol
    private let imageRepository: PosterImageRepositoryType
    private let moviesDataSource: MoviesDataSourceType
    
    init(network: NetworkManagerProtocol) {
        self.network = network
        self.imageRepository = DefaultPosterImageRepository(networkManager: network)
        self.moviesDataSource = TMDBDataSource(networkManager: network)
    }
    
    func getMoviesViewController(coordinator: Coordinator?) -> UIViewController {
        let popularMoviesUseCase = GetPopularMoviesUseCase(moviesDataSource: moviesDataSource)
        let moviesViewModel = MoviesViewModel(popularMoviesUseCase: popularMoviesUseCase)
        let moviesViewController = MoviesViewController.create(
            with: moviesViewModel,
            posterImageRepository: imageRepository,
            coordinator: coordinator)
        return moviesViewController
    }
}

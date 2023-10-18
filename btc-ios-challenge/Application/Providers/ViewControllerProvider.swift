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
    private let localStorage: LocalMovieRepositoryType
    
    init(network: NetworkManagerProtocol) {
        self.network = network
        self.imageRepository = DefaultPosterImageRepository(networkManager: network)
        self.moviesDataSource = TMDBDataSource(networkManager: network)
        self.localStorage = DefaultMovieRepository()
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
    
    func getFavoriteMoviesViewController(coordinator: Coordinator?) -> UIViewController {
        let favoriteMoviesUseCase = GetFavoriteMoviesUseCase(repository: localStorage)
        let favoritesViewModel = FavoritesViewModel(favoriteMoviesUseCase: favoriteMoviesUseCase)
        let favoritesViewController = FavoritesViewController.create(
            with: favoritesViewModel,
            posterImageRepository: imageRepository,
            coordinator: coordinator)
        return favoritesViewController
    }
    
    func getMovieDetailsController(movie: MovieResponse) -> UIViewController {
        let saveFavoriteMovieUseCase = SaveFavoriteMovieUseCase(repository: localStorage)
        let deleteMovieFromFavoritesUseCase = DeleteMovieFromFavoritesUseCase(repository: localStorage)
        let movieFavoriteStatusUseCase = GetMovieFavoriteStatusUseCase(localStorage: localStorage)
        let movieDetailsUseCase = GetMovieDetailsUseCase(moviesDataSource: moviesDataSource)
        let movieDetailsViewModel = MovieDetailsViewModel(
            movie: movie,
            movieDetailsUseCase: movieDetailsUseCase,
            saveFavoriteMovieUseCase: saveFavoriteMovieUseCase,
            deleteMovieFromFavoritesUseCase: deleteMovieFromFavoritesUseCase,
            movieFavoriteStatusUseCase: movieFavoriteStatusUseCase)
        let movieDetailsViewController = MovieDetailsViewController.create(with: movieDetailsViewModel,
                                                                           posterImageRepository: imageRepository)
        return movieDetailsViewController
    }
}

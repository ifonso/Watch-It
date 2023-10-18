//
//  MovieDetailsViewModel.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 08/10/23.
//

import Foundation
import Combine

final class MovieDetailsViewModel {
    
    @Published private(set) var movieData: MovieDetailsResponse?
    @Published private(set) var isFavoriteMovie: Bool
    
    private var cancellables = Set<AnyCancellable>()
    private var error: Error?
    
    private let deleteMovieFromFavoritesUseCase: DeleteMovieFromFavoritesUseCaseType
    private let movieFavoriteStatusUseCase: GetMovieFavoriteStatusUseCaseType
    private let saveFavoriteMovieUseCase: SaveFavoriteMovieUseCaseType
    private let movieDetailsUseCase: GetMovieDetailsUseCaseType
    private let moiveInfo: MovieResponse
    
    init(movie: MovieResponse,
         movieDetailsUseCase: GetMovieDetailsUseCaseType,
         saveFavoriteMovieUseCase: SaveFavoriteMovieUseCaseType,
         deleteMovieFromFavoritesUseCase: DeleteMovieFromFavoritesUseCaseType,
         movieFavoriteStatusUseCase: GetMovieFavoriteStatusUseCaseType
    ) {
        self.movieDetailsUseCase = movieDetailsUseCase
        self.saveFavoriteMovieUseCase = saveFavoriteMovieUseCase
        self.deleteMovieFromFavoritesUseCase = deleteMovieFromFavoritesUseCase
        self.movieFavoriteStatusUseCase = movieFavoriteStatusUseCase
        self.moiveInfo = movie
        self.isFavoriteMovie = false
    }
    
    func viewDidLoad() {
        isFavoriteMovie = movieFavoriteStatusUseCase.execute(movieID: moiveInfo.id)
        fetchAndUpdateMovieFor(id: moiveInfo.id)
    }
    
    func didTapSave() {
        guard let movie = movieData, !isFavoriteMovie
        else { return }
        saveFavoriteMovieUseCase.execute(movie: movie)
        isFavoriteMovie = true
    }
    
    func didTapRemove() {
        guard let movie = movieData, isFavoriteMovie
        else { return }
        deleteMovieFromFavoritesUseCase.execute(movieID: movie.id)
        isFavoriteMovie = false
    }
    
    private func fetchAndUpdateMovieFor(id: Int) {
        Task { @MainActor [weak self] in
            guard let result = await self?.movieDetailsUseCase.execute(id: id) else { return }
            
            switch result {
            case .success(let data):
                self?.movieData = data
            case .failure(let error):
                self?.error = error
            }
        }
        .store(in: &cancellables)
    }
}

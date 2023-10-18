//
//  FavoritesViewModel.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 13/10/23.
//

import Foundation
import Combine

final class FavoritesViewModel {
    
    @Published private(set) var movies: [MovieDetailsResponse] = []
    @Published private(set) var error: Error? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    private let favoriteMoviesUseCase: GetFavoriteMoviesUseCaseType
    
    init(favoriteMoviesUseCase: GetFavoriteMoviesUseCaseType) {
        self.favoriteMoviesUseCase = favoriteMoviesUseCase
    }
    
    func viewDidLoad() {
        let data = favoriteMoviesUseCase.execute()
        switch data {
        case .success(let moviesData):
            self.movies = moviesData
        case .failure(let error):
            self.error = error
        }
    }
}

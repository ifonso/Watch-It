//
//  SaveFavoriteMovieUseCase.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 13/10/23.
//

import Foundation

final class SaveFavoriteMovieUseCase: SaveFavoriteMovieUseCaseType {
    
    private let localStorage: LocalMovieRepositoryType
    
    init(repository: LocalMovieRepositoryType) {
        self.localStorage = repository
    }
    
    func execute(movie: MovieDetailsResponse) {
        do {
            try localStorage.save(movie: movie)
        } catch {
            NSLog("Error while saving movie: \(error.localizedDescription)")
        }
    }
}

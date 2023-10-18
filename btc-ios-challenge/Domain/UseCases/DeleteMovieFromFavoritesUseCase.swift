//
//  DeleteMovieFromFavoritesUseCase.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 13/10/23.
//

import Foundation

final class DeleteMovieFromFavoritesUseCase: DeleteMovieFromFavoritesUseCaseType {

    private let localStorage: LocalMovieRepositoryType
    
    init(repository: LocalMovieRepositoryType) {
        self.localStorage = repository
    }
    
    func execute(movieID: Int) {
        do {
            try localStorage.delete(id: movieID)
        } catch {
            NSLog("Error while deleting movie: \(error.localizedDescription)")
        }
    }
}

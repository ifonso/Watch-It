//
//  GetMovieFavoriteStatusUseCase.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 17/10/23.
//

import Foundation

final class GetMovieFavoriteStatusUseCase: GetMovieFavoriteStatusUseCaseType {
    
    private let repository: LocalMovieRepositoryType
    
    init(localStorage: LocalMovieRepositoryType) {
        self.repository = localStorage
    }
    
    func execute(movieID id: Int) -> Bool {
        return repository.isFavorite(id: id)
    }
}

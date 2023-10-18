//
//  GetFavoriteMoviesUseCaseType.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 13/10/23.
//

import Foundation

protocol GetFavoriteMoviesUseCaseType {
    /// Fetch favorite movies from local storage
    func execute() -> Result<[MovieDetailsResponse], LocalStorageErrors>
}

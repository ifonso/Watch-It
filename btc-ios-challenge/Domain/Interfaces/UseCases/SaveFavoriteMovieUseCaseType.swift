//
//  SaveFavoriteMovieUseCaseType.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 13/10/23.
//

import Foundation

protocol SaveFavoriteMovieUseCaseType {
    /// Save movie in local storage
    func execute(movie: MovieDetailsResponse)
}

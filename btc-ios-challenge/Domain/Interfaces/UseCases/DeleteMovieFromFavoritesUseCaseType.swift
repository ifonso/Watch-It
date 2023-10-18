//
//  DeleteMovieFromFavoritesUseCaseType.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 17/10/23.
//

import Foundation

protocol DeleteMovieFromFavoritesUseCaseType {
    /// Delete `Movie` from favorites
    func execute(movieID: Int)
}

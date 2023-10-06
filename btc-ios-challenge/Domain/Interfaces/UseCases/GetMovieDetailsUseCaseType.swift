//
//  GetMovieDetailsUseCaseType.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 06/10/23.
//

import Foundation

protocol GetMovieDetailsUseCaseType {
    /// Get details for a specific movie
    func execute(id number: Int) async -> Result<MovieDetailsResponse?, TMDBErros>
}

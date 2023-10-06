//
//  GetPopularMoviesUseCaseType.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 01/10/23.
//

import Foundation

protocol GetPopularMoviesUseCaseType {
    /// Fetch popular movies with pagination
    func execute(page number: Int) async -> Result<PopularMoviesResponse, TMDBErros>
}

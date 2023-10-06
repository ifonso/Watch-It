//
//  MoviesDataSouceType.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 30/09/23.
//

import Foundation

protocol MoviesDataSourceType {
    func getPopularMovies(page: Int) async throws -> PopularMoviesResponse
    func getMovieDetails(id: Int) async throws -> MovieDetailsResponse?
}

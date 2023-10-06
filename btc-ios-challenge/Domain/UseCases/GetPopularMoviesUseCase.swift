//
//  GetPopularMoviesUseCase.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 01/10/23.
//

import Foundation

final class GetPopularMoviesUseCase: GetPopularMoviesUseCaseType {
    
    private let dataSource: MoviesDataSourceType
    
    init(moviesDataSource: MoviesDataSourceType) {
        self.dataSource = moviesDataSource
    }
    
    func execute(page number: Int) async -> Result<PopularMoviesResponse, TMDBErros> {
        do {
            return .success(try await dataSource.getPopularMovies(page: number))
        } catch let error as TMDBErros {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
}

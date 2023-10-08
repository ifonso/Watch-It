//
//  GetMovieDetailsUseCase.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 06/10/23.
//

import Foundation

final class GetMovieDetailsUseCase: GetMovieDetailsUseCaseType {
    
    private let dataSource: MoviesDataSourceType
    
    init(moviesDataSource: MoviesDataSourceType) {
        self.dataSource = moviesDataSource
    }
    
    func execute(id number: Int) async -> Result<MovieDetailsResponse?, TMDBErros> {
        do {
            return .success(try await dataSource.getMovieDetails(id: number))
        } catch let error as TMDBErros {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
}

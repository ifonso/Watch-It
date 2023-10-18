//
//  GetFavoriteMoviesUseCase.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 13/10/23.
//

import Foundation

final class GetFavoriteMoviesUseCase: GetFavoriteMoviesUseCaseType {
    
    private let repository: LocalMovieRepositoryType
    
    init(repository: LocalMovieRepositoryType) {
        self.repository = repository
    }
    
    func execute() -> Result<[MovieDetailsResponse], LocalStorageErrors> {
        do {
            return .success(try repository.findAll())
        } catch let error as LocalStorageErrors {
            return .failure(error)
        } catch {
            return .failure(.unknown)
        }
    }
}

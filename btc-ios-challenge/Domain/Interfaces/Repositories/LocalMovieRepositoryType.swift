//
//  LocalMovieRepositoryType.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 10/10/23.
//

import Foundation

protocol LocalMovieRepositoryType {
    
    func isFavorite(id: Int) -> Bool
    func findAll() throws -> [MovieDetailsResponse]
    
    func save(movie data: MovieDetailsResponse) throws
    func delete(id: Int) throws
}

//
//  MovieListItemDTO.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 28/09/23.
//

import Foundation

struct MovieListItemDTO {
    
    let title: String
    let year: String
    
    init(movie: MovieResponse) {
        self.title = movie.title
        self.year = format(data: movie.year)
    }
    
    init(movie: MovieDetailsResponse) {
        self.title = movie.title
        self.year = format(data: movie.year)
    }
}

private func format(data: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    
    guard let release = getDateFrom(data)
    else { return "2023"}
    
    return formatter.string(from: release)
}

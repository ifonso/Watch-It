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
        
        if let release = getDateFrom(movie.year) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            self.year = formatter.string(from: release)
        } else {
            self.year = "2023"
        }
    }
}

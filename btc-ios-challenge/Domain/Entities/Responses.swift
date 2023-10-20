//
//  Responses.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 06/10/23.
//

import Foundation

struct PopularMoviesResponse: Decodable {
    let page: Int
    let movies: [MovieResponse]
    let pages: Int
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case pages = "total_pages"
        case total = "total_results"
    }
}

struct MovieResponse: Decodable, Identifiable {
    let id: Int
    let title: String
    let year: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case year = "release_date"
        case poster = "poster_path"
    }
    
    func getPosterUrlString(size p: Poster) -> String {
        return "https://image.tmdb.org/t/p/w\(p.size)\(poster)"
    }
}

struct MovieDetailsResponse: Decodable, Identifiable {
    let id: Int
    let title: String
    let genres: [Genre]
    let overview: String
    let poster: String
    let rating: Double
    let year: String
    
    enum CodingKeys: String, CodingKey {
        case id, genres, overview, title
        case poster = "poster_path"
        case rating = "vote_average"
        case year = "release_date"
    }
    
    func getPosterUrlString(size p: Poster) -> String {
        return "https://image.tmdb.org/t/p/w\(p.size)\(poster)"
    }
}

struct Genre: Decodable {
    let name: String
}

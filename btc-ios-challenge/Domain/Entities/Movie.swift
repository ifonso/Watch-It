//
//  Movie.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 27/09/23.
//

import Foundation

struct Movie: Codable, Identifiable {
    let id: String
    let title: String
    let synopsis: String
    let rating: String
    let genres: [String]
    let poster: URL
}

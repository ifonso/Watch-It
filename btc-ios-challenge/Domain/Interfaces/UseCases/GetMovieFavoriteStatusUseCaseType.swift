//
//  GetMovieFavoriteStatusUseCaseType.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 17/10/23.
//

import Foundation

protocol GetMovieFavoriteStatusUseCaseType {
    /// Return true if `Movie` is in favorites otherwise return false
    func execute(movieID id: Int) -> Bool
}

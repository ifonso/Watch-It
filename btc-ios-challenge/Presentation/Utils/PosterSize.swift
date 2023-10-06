//
//  PosterSize.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 28/09/23.
//

import Foundation

enum Poster {
    case small
    case medium
    case large
    
    var size: Int {
        switch self {
        case .small:
            return 185
        case .medium:
            return 342
        case .large:
            return 500
        }
    }
}

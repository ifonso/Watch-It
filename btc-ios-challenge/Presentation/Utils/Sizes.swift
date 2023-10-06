//
//  Sizes.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 28/09/23.
//

import Foundation

enum Sizes {
    enum System {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
    
    enum Components {
        static let poster: CGSize = CGSize(width: 66, height: 100)
        static let movieCell: CGSize = CGSize(width: .zero, height: 132)
    }
    
    enum Text {
        static let homeMovieTitle: CGFloat = 16
        static let homeMovieDate: CGFloat = 10
    }
}

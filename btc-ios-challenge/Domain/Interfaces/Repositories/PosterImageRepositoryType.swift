//
//  PosterImageRepositoryType.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 28/09/23.
//

import UIKit
import Combine

protocol PosterImageRepositoryType {
    // Loads image for the given movie
    func loadImage(from image: String) async -> UIImage?
}

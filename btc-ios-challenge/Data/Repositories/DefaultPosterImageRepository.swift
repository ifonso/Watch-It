//
//  DefaultPosterImageRepository.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 30/09/23.
//

import Foundation
import UIKit

final class DefaultPosterImageRepository: PosterImageRepositoryType {
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func loadImage(from image: String) async -> UIImage? {
        let url = URL(string: image)!
        let result = await networkManager.fetch(from: url,
                                                method: .get,
                                                params: nil,
                                                headers: nil)
        switch result {
        case .success(let data):
            return UIImage(data: data)
        case .failure(let error):
            NSLog(error.localizedDescription)
            return nil
        }
    }
}

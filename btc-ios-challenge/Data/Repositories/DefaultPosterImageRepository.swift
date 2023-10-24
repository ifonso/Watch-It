//
//  DefaultPosterImageRepository.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 30/09/23.
//

import Foundation
import UIKit

private struct CacheConfig {
    let countLimit: Int
    let memoryLimit: Int
}

final class DefaultPosterImageRepository: PosterImageRepositoryType {
    
    private let networkManager: NetworkManagerProtocol
    
    private let lock = NSLock()
    
    private lazy var cacheConfig: CacheConfig = {
        let maxMemorySize = 1024 * 1024  * 100 // 100MB
        return CacheConfig(countLimit: 100,
                           memoryLimit: maxMemorySize)
    }()
    
    private lazy var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = cacheConfig.countLimit
        cache.totalCostLimit = cacheConfig.memoryLimit
        return cache
    }()
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func loadImage(from image: String) async -> UIImage? {
        if let cachedImage = getImageFromCache(with: image) {
            return cachedImage
        }
        
        let url = URL(string: image)!
        let result = await networkManager.fetch(from: url,
                                                method: .get,
                                                params: nil,
                                                headers: nil)
        
        switch result {
        case .success(let data):
            guard let downloadedImage = UIImage(data: data)
            else { return nil }
            saveImageInCache(image: downloadedImage, url: image)
            return downloadedImage
        case .failure(let error):
            NSLog(error.localizedDescription)
            return nil
        }
    }
    
    // MARK: Cache utility
    private func getImageFromCache(with url: String) -> UIImage? {
        lock.lock()
        defer { lock.unlock() }
        
        guard let image = imageCache.object(forKey: NSString(string: url))
        else { return nil }
        
        return image
    }
    
    private func saveImageInCache(image: UIImage, url: String) {
        lock.lock()
        defer { lock.unlock() }
        imageCache.setObject(image, forKey: NSString(string: url))
    }
}

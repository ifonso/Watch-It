//
//  TMDBDataSource.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 27/09/23.
//

import Foundation

enum TMDBErros: Error {
    case failFetch
    case failDecode
    case unknown
}

final class TMDBDataSource: MoviesDataSourceType {
    
    init(networkManager: NetworkManagerProtocol) {
        self.network = networkManager
        self.decoder = JSONDecoder()
        
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("No API_KEY provided on Info.plist")
        }
        
        self.API_KEY = key
    }
    
    private let network: NetworkManagerProtocol
    private let decoder: JSONDecoder
    
    private let BASE_URL: String = "https://api.themoviedb.org"
    private let API_KEY: String
    
    func getPopularMovies(page: Int) async throws -> PopularMoviesResponse {
        let popularMoviesUrl = BASE_URL + "/3/movie/popular"
        let url = URL(string: popularMoviesUrl)!
        let params = ["language": "en-US", "page": String(page)]
        let headers = ["accept": "application/json", "Authorization": "Bearer \(API_KEY)"]
        
        let data = await network.fetch(from: url,
                                       method: .get,
                                       params: params,
                                       headers: headers)
        switch data {
        case .success(let result):
            do {
                return try decode(result)
            } catch {
                throw TMDBErros.failDecode
            }
        case .failure(_):
            throw TMDBErros.failFetch
        }
    }
    
    func getMovieDetails(id: Int) async throws -> MovieDetailsResponse? {
        let detailsUrl = BASE_URL + "/3/movie/\(id)"
        let url = URL(string: detailsUrl)!
        let params = ["language": "en-US"]
        let headers = ["accept": "application/json", "Authorization": "Bearer \(API_KEY)"]
        
        let data = await network.fetch(from: url,
                                       method: .get,
                                       params: params,
                                       headers: headers)
        
        switch data {
        case .success(let result):
            do {
                return try decode(result)
            } catch {
                return nil
            }
        case .failure(_):
            throw TMDBErros.failFetch
        }
    }
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        return try decoder.decode(T.self, from: data)
    }
}
